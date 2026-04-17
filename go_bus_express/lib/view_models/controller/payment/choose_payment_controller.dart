import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/models/body/booking_body.dart';
import 'package:go_bus_express/models/body/payment_body.dart';
import 'package:go_bus_express/models/booking/booking_model.dart';
import 'package:go_bus_express/models/payment/generate_qr_model.dart';
import 'package:go_bus_express/models/payment/pending_payment_model.dart';
import 'package:go_bus_express/repository/booking_repository.dart';
import 'package:go_bus_express/repository/hive_manager_repository.dart';
import 'package:go_bus_express/utils/enums/currency_enum.dart';
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
  ) : super(ChoosePaymentState());

  final BookingRepository _bookingRepository;
  final LocalRepository _localRepository;
  final HiveManagerRepository _hiveManager;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      log('❌ No arguments passed to ChoosePaymentController');
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

  void createBooking() async {
    try {
      final body = BookingBody(
        scheduleId: state.scheduleId,
        seatIds: state.selectedSeatIds,
      );
      updateState((state) => state.copyWith(isLoading: true));
      log('🔄 Creating booking with seat IDs: ${state.selectedSeatIds}');
      log('📤 Booking body: ${body.toJson()}');

      final result = await _bookingRepository.createBooking(body: body);
      log('📥 Booking API response received');

      switch (result) {
        case Success<BookingModel?>():
          log('✅ Booking created successfully');
          final bookingId = result.data?.id;
          log('✅ Booking ID: $bookingId');

          if (bookingId != null) {
            log('🔄 Proceeding to generate QR code...');
            await _generateQr(bookingId);
          } else {
            log('❌ Booking ID is null');
            updateState((state) => state.copyWith(isLoading: false));
            _showError('Booking created but ID is missing');
          }
          break;

        case Error<BookingModel?>():
          log('❌ Booking creation error: ${result.error.displayMessage}');
          log('❌ Error code: ${result.error.statusCode}');
          updateState((state) => state.copyWith(isLoading: false));
          _showError(result.error.displayMessage);
          break;
      }
    } catch (e, stackTrace) {
      log('❌ Exception in createBooking: $e');
      log('Stack trace: $stackTrace');
      updateState((state) => state.copyWith(isLoading: false));
      _showError('Failed to create booking. Please try again.');
    }
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
