import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/models/body/verify_payment_body.dart';
import 'package:go_bus_express/models/payment/verify_payment_model.dart';
import 'package:go_bus_express/repository/booking_repository.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/utils/enums/payment_status_enum.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/payment/kh_qr/kh_qr_state.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/network/x_result.dart';

class KhQrController extends BaseController<KhQrState> {
  final BookingRepository _bookingRepo;
  final LocalRepository _localRepository;
  Timer? _countdownTimer;
  Timer? _verificationTimer;

  static const int _verificationIntervalSeconds = 5; // Poll every 5 seconds
  static const int _maxRetries = 36; // 36 * 5 = 180 seconds (3 minutes)
  int _retryCount = 0;

  KhQrController(this._bookingRepo, this._localRepository) : super(KhQrState());

  @override
  void onInit() {
    super.onInit();
    _loadMd5();
    _initializeFromArguments();
    _startCountdownTimer();
    _startVerificationPolling();
  }

  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      log('❌ No arguments passed to KhQrController');
      return;
    }

    final qrData = args['qrData'] as String? ?? '';
    final amount = (args['amount'] as num?)?.toDouble() ?? 0.0;
    final currency = args['currency'] as String? ?? 'USD';
    final bookingId = args['bookingId'] as int? ?? 0;
    updateState(
      (state) => state.copyWith(
        qrData: qrData,
        amount: amount,
        currency: currency,
        bookingId: bookingId,
      ),
    );

    log('✅ KHQR initialized: BookingId: $bookingId, Amount: \$$amount');
    log('✅ KHQR initialized:  Qr Data: \$$qrData');
  }

  // MARK: API Call - Verify Payment

  void _verifyPayment() async {
    // Don't verify if already paid or expired
    if (state.isPaid || state.isExpired) {
      _stopVerificationPolling();
      return;
    }

    // Check retry limit
    if (_retryCount >= _maxRetries) {
      log('⚠️ Max verification retries reached');
      _stopVerificationPolling();
      return;
    }

    _retryCount++;
    log('🔍 Verifying payment (attempt $_retryCount/$_maxRetries)...');

    final body = VerifyPaymentBody(md5: state.md5, bookingId: state.bookingId);

    final result = await _bookingRepo.verifyMd5(body: body);

    switch (result) {
      case Success<VerifyPaymentModel>():
        {
          final payment = result.data;
          if (payment.status == PaymentStatusEnum.paid.status) {
            log('✅ Payment verified successfully!');
            updateState(
              (state) => state.copyWith(
                isPaid: true,
                paymentStatus: payment.status,
                transactionId: payment.transactionId,
              ),
            );
            _stopVerificationPolling();
            _stopCountdownTimer();
            // Navigate to success screen
            _handlePaymentSuccess();
          } else {
            log('⏳ Payment status: ${payment.status}');
          }
        }
      case Error<VerifyPaymentModel>():
        {
          log('❌ Verification error: ${result.error.displayMessage}');
          // Show error only on first few attempts to avoid spam
          if (_retryCount <= 3) {
            _showError(result.error.displayMessage);
          }
          // Continue polling on error
        }
    }
  }

  void _handlePaymentSuccess() {
    Get.offAllNamed(AppRoutes.mainNavigation);
  }

  // MARK: Local Storage

  void _loadMd5() async {
    final md5 = _localRepository.getMD5();
    updateState((state) => state.copyWith(md5: md5));
    log('📝 Loaded MD5: $md5');
  }

  // MARK: Timers

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0 && !state.isPaid) {
        updateState(
          (state) =>
              state.copyWith(remainingSeconds: state.remainingSeconds - 1),
        );
      } else {
        _stopCountdownTimer();
        if (!state.isPaid) {
          updateState((state) => state.copyWith(isExpired: true));
          _stopVerificationPolling();
          _cancelBooking(); // ← Cancel booking when timer expires
          log('⏰ Payment session expired');
        }
      }
    });
  }

  void _startVerificationPolling() {
    // First check immediately
    _verifyPayment();

    // Then check every 5 seconds
    _verificationTimer = Timer.periodic(
      Duration(seconds: _verificationIntervalSeconds),
      (timer) => _verifyPayment(),
    );

    log(
      '🔄 Started payment verification polling (every $_verificationIntervalSeconds seconds)',
    );
  }

  void _stopCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  void _stopVerificationPolling() {
    _verificationTimer?.cancel();
    _verificationTimer = null;
    log('⏹️ Stopped payment verification polling');
  }

  // MARK: API Cancel Booking
  void _cancelBooking() async {
    if (state.bookingId == 0) {
      log('⚠️ No booking ID to cancel');
      return;
    }

    final result = await _bookingRepo.cancelBooking(bookingId: state.bookingId);

    switch (result) {
      case Success<void>():
        {
          log('✅ Booking ${state.bookingId} canceled successfully');
        }
      case Error<void>():
        {
          log('❌ Failed to cancel booking: ${result.error.displayMessage}');
          _showError(
            'Failed to cancel booking: ${result.error.displayMessage}',
          );
        }
    }
  }

  String formatTime() {
    final seconds = state.remainingSeconds;
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  bool isLowTime() {
    return state.remainingSeconds <= 30;
  }

  void _showError(String message) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();

    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        titleText: Text(
          'Error'.tr,
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        messageText: Text(message, style: TextStyle(color: white)),
      ),
    );
  }

  @override
  void onClose() {
    _stopCountdownTimer();
    _stopVerificationPolling();
    super.onClose();
  }
}
