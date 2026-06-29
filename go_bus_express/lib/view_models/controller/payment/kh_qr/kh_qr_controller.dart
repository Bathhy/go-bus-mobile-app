import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_bus_express/core/services/payment_sound_service.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/services/local_notification_service.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/models/body/payment_body.dart';
import 'package:go_bus_express/models/body/verify_payment_body.dart';
import 'package:go_bus_express/models/payment/generate_qr_model.dart';
import 'package:go_bus_express/models/payment/verify_payment_model.dart';
import 'package:go_bus_express/repository/booking_repository.dart';
import 'package:go_bus_express/repository/hive_manager_repository.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/payment/kh_qr/kh_qr_state.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/network/base_response.dart';
import 'package:shared_package/network/x_result.dart';

class KhQrController extends BaseController<KhQrState> {
  final BookingRepository _bookingRepo;
  final LocalRepository _localRepository;
  final HiveManagerRepository _hiveManager;

  // Triggers the error dialog in the view; null = no error
  final Rx<String?> paymentError = Rx<String?>(null);

  KhQrController(this._bookingRepo, this._localRepository, this._hiveManager)
    : super(KhQrState());

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
    _getLocalMd5();
    _verifyPayment();
  }

  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) return;

    final qrData = args['qrData'] as String? ?? '';
    final amount = (args['amount'] as num?)?.toDouble() ?? 0.0;
    final currency = args['currency'] as String? ?? 'USD';
    final bookingId = args['bookingId'] as int? ?? 0;
    final createdAt = args['createdAt'] as DateTime?;

    log('QR Data: $qrData');
    updateState(
      (state) => state.copyWith(
        qrData: qrData,
        amount: amount,
        currency: currency,
        bookingId: bookingId,
        createdAt: createdAt,
      ),
    );
  }

  // MARK: - Verify Payment (POST /checking-transaction)

  void _verifyPayment() async {
    if (state.isPaid || state.isExpired) return;

    log('Calling verify payment API...');

    final body = VerifyPaymentBody(md5: state.md5);
    final result = await _bookingRepo.verifyMd5(
      body: body,
      bookingId: state.bookingId.toString(),
    );

    switch (result) {
      case Success<BaseResponse<VerifyPaymentModel>>():
        final statusCode = result.data.status;
        log('Verify response status: $statusCode');

        if (statusCode == 200) {
          await _onPaymentSuccess();
        } else {
          // Backend returned non-200 body: FAILED or EXPIRED
          log('Payment not completed – status: $statusCode');
          paymentError.value = 'failed';
        }

      case Error<BaseResponse<VerifyPaymentModel>>():
        log('Verify error: ${result.error.displayMessage}');
        // Wait briefly then fall back to GET booking payment status
        await Future.delayed(const Duration(seconds: 2));
        await _fallbackCheckPaymentStatus();
    }
  }

  // MARK: - Fallback (GET /payments/booking/{bookingId})

  Future<void> _fallbackCheckPaymentStatus() async {
    log('Fallback: GET /payments/booking/${state.bookingId}');

    final result = await _bookingRepo.getPaymentByBookingId(
      bookingId: state.bookingId,
    );

    switch (result) {
      case Success<BaseResponse<Payment>>():
        final status = (result.data.data?.status ?? '').toUpperCase();
        log('Fallback payment status: $status');

        switch (status) {
          case 'SUCCESS':
          case 'PAID':
          case 'COMPLETED':
            await _onPaymentSuccess();

          case 'PENDING':
          case 'PROCESSING':
            paymentError.value = 'pending';

          default:
            // FAILED, EXPIRED, TIMEOUT, or unknown
            paymentError.value = 'failed';
        }

      case Error<BaseResponse<Payment>>():
        log('Fallback check failed: ${result.error.displayMessage}');
        paymentError.value = 'error';
    }
  }

  // MARK: - Retry (re-generate QR + start new verify cycle)

  Future<void> retryPayment() async {
    paymentError.value = null;
    updateState((s) => s.copyWith(isLoading: true, qrData: ''));

    final body = PaymentBody(
      bookingId: state.bookingId,
      currency: state.currency,
    );

    final result = await _bookingRepo.generateQr(body: body);

    switch (result) {
      case Success<BaseResponse<GenerateQrModel>>():
        final qr = result.data.data?.data?.qr ?? '';
        final md5 = result.data.data?.data?.md5 ?? '';

        await _localRepository.saveMD5(md5);

        updateState((s) => s.copyWith(isLoading: false, qrData: qr, md5: md5));
        _verifyPayment();

      case Error<BaseResponse<GenerateQrModel>>():
        updateState((s) => s.copyWith(isLoading: false));
        _showError(result.error.displayMessage);
    }
  }

  // MARK: - Payment Success

  Future<void> _onPaymentSuccess() async {
    // Play "ting" + haptic the instant we know payment succeeded —
    // before navigation so the user feels the confirmation immediately.
    PaymentSoundService.playSuccess();

    updateState((s) => s.copyWith(isPaid: true));
    await _hiveManager.clearPendingPayment();
    _clearLocalMd5();
    _showPaymentSuccessNotification();
    _handlePaymentSuccess();
  }

  void _handlePaymentSuccess() {
    updateState((state) => state.copyWith(isLoading: false));
    Get.offAllNamed(AppRoutes.paymentSuccess);
  }

  void _showPaymentSuccessNotification() {
    LocalNotificationService().showPaymentSuccessNotification(
      bookingId: state.bookingId,
      amount: state.amount,
      currency: state.currency,
    );
  }

  // MARK: - Cancel Booking

  void cancelBooking() async {
    if (state.bookingId == 0) return;

    updateState((state) => state.copyWith(isLoading: true));

    final result = await _bookingRepo.cancelBooking(bookingId: state.bookingId);

    switch (result) {
      case Success<void>():
        updateState((state) => state.copyWith(isLoading: false));
        _clearLocalMd5();
        await _hiveManager.clearPendingPayment();
        Get.offAllNamed(AppRoutes.mainNavigation);

      case Error<void>():
        updateState((state) => state.copyWith(isLoading: false));
        _showError(
          'Failed to cancel booking: ${result.error.displayMessage}',
        );
    }
  }

  // MARK: - Helpers

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).clearSnackBars();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error'.tr,
                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                ),
                Text(message, style: TextStyle(color: white)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _getLocalMd5() async {
    final md5 = _localRepository.getMD5();
    updateState((state) => state.copyWith(md5: md5));
  }

  void _clearLocalMd5() async => await _localRepository.removeMD5();
}
