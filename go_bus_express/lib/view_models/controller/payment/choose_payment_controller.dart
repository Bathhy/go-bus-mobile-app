import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/models/body/booking_body.dart';
import 'package:go_bus_express/models/body/payment_body.dart';
import 'package:go_bus_express/models/booking/booking_model.dart';
import 'package:go_bus_express/models/payment/generate_qr_model.dart';
import 'package:go_bus_express/models/payment/pending_payment_model.dart';
import 'package:go_bus_express/models/wallet/wallet_model.dart';
import 'package:go_bus_express/repository/booking_repository.dart';
import 'package:go_bus_express/repository/hive_manager_repository.dart';
import 'package:go_bus_express/repository/wallet_repository.dart';
import 'package:go_bus_express/utils/enums/currency_enum.dart';
import 'package:go_bus_express/view/wallet/pin/wallet_pay_pin_dialog.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/payment/choose_payment_state.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/network/base_response.dart';
import 'package:shared_package/network/x_result.dart';

import '../../../resources/routes/app_routes.dart';

class ChoosePaymentController extends BaseController<ChoosePaymentState> {
  ChoosePaymentController(
    this._bookingRepository,
    this._localRepository,
    this._hiveManager,
    this._walletRepository,
  ) : super(ChoosePaymentState());

  final BookingRepository _bookingRepository;
  final LocalRepository _localRepository;
  final HiveManagerRepository _hiveManager;
  final WalletRepository _walletRepository;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
    _fetchWalletBalance();
  }

  Future<void> _fetchWalletBalance() async {
    final result = await _walletRepository.getWalletInfo();
    switch (result) {
      case Success():
        updateState((s) => s.copyWith(walletBalance: result.data?.balance ?? 0.0));
        break;
      case Error():
        log('Failed to fetch wallet balance: ${result.error.displayMessage}');
        break;
    }
  }

  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      log('No arguments passed to ChoosePaymentController');
      return;
    }

    // Extract data from arguments
    final origin = args['origin'] as String? ?? '';
    final destination = args['destination'] as String? ?? '';
    final departureDate = args['departureDate'] as String?;
    final departureTime = args['departureTime'] as String? ?? '';
    final selectedSeats = args['selectedSeats'] as List<String>? ?? [];
    final selectedSeatIds =
        (args['selectedSeatIds'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList() ??
        [];
    final unitPrice = (args['unitPrice'] as num?)?.toDouble() ?? 0.0;
    final discount = (args['discount'] as num?)?.toDouble() ?? 0.0;
    final scheduleId = args['scheduleId'] as int?;

    // Format direction
    final direction = '$origin - $destination';

    updateState(
      (state) => state.copyWith(
        direction: direction,
        departureDate: departureDate,
        departureTime: departureTime,
        selectedSeats: selectedSeats,
        selectedSeatIds: selectedSeatIds,
        unitPrice: unitPrice,
        discount: discount,
        scheduleId: scheduleId,
      ),
    );
  }

  void selectPaymentMethod(String method) {
    updateState((state) => state.copyWith(selectedPaymentMethod: method));
  }

  void toggleTermsAgreement() {
    updateState((state) => state.copyWith(agreedToTerms: !state.agreedToTerms));
  }

  bool canProceedToPayment() {
    return state.agreedToTerms && state.selectedSeats.isNotEmpty;
  }

  /// True when the user already has an active wallet session (no PIN needed).
  bool get walletSessionValid => _localRepository.isWalletSessionValid();

  void createBooking({required String paymentMethod}) async {
    try {
      // ── Step 1: Wallet PIN gate — BEFORE booking is created ────────────────
      // This prevents orphaned bookings when the user cancels the PIN dialog.
      String? walletSessionToken;
      if (paymentMethod == 'Wallet') {
        walletSessionToken = await _ensureWalletSession();
        if (walletSessionToken == null) return; // user cancelled PIN
      }

      // ── Step 2: Create booking ─────────────────────────────────────────────
      final body = BookingBody(
        scheduleId: state.scheduleId,
        seatIds: state.selectedSeatIds,
      );
      updateState((state) => state.copyWith(isLoading: true));
      log('Creating booking with seat IDs: ${state.selectedSeatIds}');

      final result = await _bookingRepository.createBooking(body: body);

      switch (result) {
        case Success<BookingModel?>():
          final bookingId = result.data?.id;
          log('Booking created, id=$bookingId');

          if (bookingId == null) {
            updateState((state) => state.copyWith(isLoading: false));
            _showError('Booking created but ID is missing');
            return;
          }

          if (paymentMethod == 'Wallet') {
            // Session is already validated — go straight to payment.
            await _doWalletPay(
              bookingId,
              walletSessionToken!,
              description: 'Pay With Wallet',
            );
          } else {
            await _generateQr(bookingId);
          }

        case Error<BookingModel?>():
          log('Booking error ${result.error.statusCode}: ${result.error.displayMessage}');
          updateState((state) => state.copyWith(isLoading: false));
          _showError(result.error.displayMessage);
      }
    } catch (e, st) {
      log('Exception in createBooking: $e\n$st');
      updateState((state) => state.copyWith(isLoading: false));
      _showError('Failed to create booking. Please try again.');
    }
  }

  // ── Wallet session helpers ──────────────────────────────────────────────────

  /// Returns a valid session token without user interaction if the session is
  /// still warm; otherwise shows the PIN dialog and returns whatever that
  /// resolves to (null if the user cancels).
  Future<String?> _ensureWalletSession() async {
    final existing = _getValidSessionToken();
    if (existing != null) {
      log('Wallet session still valid — skipping PIN');
      return existing;
    }
    log('Wallet session invalid — prompting PIN before booking');
    return _showPinDialog();
  }

  Future<void> _doWalletPay(
    int bookingId,
    String sessionToken, {
    bool isRetry = false,
    String? description,
  }) async {
    final result = await _bookingRepository.payWithWallet(
      bookingId: bookingId,
      sessionToken: sessionToken,
      description: description,
    );

    switch (result) {
      case Success():
        updateState((s) => s.copyWith(isLoading: false));
        Get.toNamed(
          AppRoutes.paymentSuccess,
          arguments: {'bookingId': bookingId, 'amount': state.totalPrice},
        );

      case Error():
        final isExpired = result.error.statusCode == 401;
        if (!isRetry && isExpired) {
          log('Wallet session expired — requesting PIN');
          await _localRepository.clearWalletSession();
          updateState((s) => s.copyWith(isLoading: false));
          final newToken = await _showPinDialog(
            subtitle: 'session_expired_enter_pin'.tr,
          );
          if (newToken != null) {
            updateState((s) => s.copyWith(isLoading: true));
            await _doWalletPay(
              bookingId,
              newToken,
              isRetry: true,
              description: description,
            );
          }
        } else {
          updateState((s) => s.copyWith(isLoading: false));
          _showError(result.error.displayMessage);
        }
    }
  }

  String? _getValidSessionToken() {
    if (!_localRepository.isWalletSessionValid()) return null;
    return _localRepository.getWalletSessionToken();
  }

  Future<String?> _showPinDialog({String? subtitle}) async {
    final context = Get.context;
    if (context == null) return null;

    return WalletPayPinDialog.show(
      context,
      subtitle: subtitle,
      onPinSubmit: (pin) async {
        final result = await _walletRepository.loginWallet(pinCode: pin);
        switch (result) {
          case Success<WalletModel?>():
            final token = result.data?.walletSessionToken;
            if (token == null) throw 'Failed to get session token';
            await _localRepository.saveWalletSession(token);
            return token;
          case Error<WalletModel?>():
            throw result.error.displayMessage;
        }
      },
    );
  }

  Future<void> _generateQr(int bookingId) async {
    try {
      final currency = CurrrencyEnum.USD.key;
      final body = PaymentBody(bookingId: bookingId, currency: currency);

      final result = await _bookingRepository.generateQr(body: body);

      switch (result) {
        case Success<BaseResponse<GenerateQrModel>>():
          {
            final qrData = result.data.data?.data?.qr ?? '';
            final md5Data = result.data.data?.data?.md5 ?? '';
            await _localRepository.saveMD5(md5Data);
            final now = DateTime.now();

            // Calculate total amount based on selected seats
            final totalAmount = state.unitPrice * state.selectedSeats.length;

            // Save pending payment to Hive
            final pendingPayment = PendingPaymentModel(
              bookingId: bookingId,
              amount: totalAmount,
              currency: currency,
              qrData: qrData,
              md5: md5Data,
              createdAt: now,
              direction: state.direction,
              selectedSeats: state.selectedSeats,
            );
            await _hiveManager.savePendingPayment(pendingPayment);

            updateState((state) => state.copyWith(isLoading: false));

            Get.toNamed(
              AppRoutes.makePayment,
              arguments: {
                'qrData': qrData,
                'md5': md5Data,
                'amount': totalAmount,
                'currency': currency,
                'bookingId': bookingId,
                'createdAt': now,
              },
            );
          }
        case Error<BaseResponse<GenerateQrModel>>():
          updateState((state) => state.copyWith(isLoading: false));
          _showError(result.error.displayMessage);
          break;
      }
    } catch (e) {
      updateState((state) => state.copyWith(isLoading: false));
      _showError('Failed to generate QR code. Please try again.');
    }
  }

  void _showError(String message) {
    final context = Get.context;
    if (context == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: white)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}
