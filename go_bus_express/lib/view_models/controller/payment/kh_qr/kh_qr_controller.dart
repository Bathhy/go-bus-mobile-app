import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/services/local_notification_service.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/models/body/verify_payment_body.dart';
import 'package:go_bus_express/models/payment/verify_payment_model.dart';
import 'package:go_bus_express/repository/booking_repository.dart';
import 'package:go_bus_express/repository/hive_manager_repository.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/utils/enums/enum.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/payment/kh_qr/kh_qr_state.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/network/x_result.dart';

class KhQrController extends BaseController<KhQrState> {
  final BookingRepository _bookingRepo;
  final LocalRepository _localRepository;
  final HiveManagerRepository _hiveManager;
  Timer? _countdownTimer;
  Timer? _verificationTimer;

  static const int _verificationIntervalSeconds = 5; // Poll every 5 seconds
  static const int _paymentTimeoutSeconds = 180; // Payment timeout duration
  static const int _maxRetries = 36; // 12 * 5 = 60 seconds (1 minute)
  int _retryCount = 0;

  KhQrController(this._bookingRepo, this._localRepository, this._hiveManager)
    : super(KhQrState());

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
    _getLocalMd5();
    _calculateRemainingTime();
    _startCountdownTimer();
    _startVerificationPolling();
  }

  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      return;
    }

    final qrData = args['qrData'] as String? ?? '';
    final amount = (args['amount'] as num?)?.toDouble() ?? 0.0;
    final currency = args['currency'] as String? ?? 'USD';
    final bookingId = args['bookingId'] as int? ?? 0;
    final createdAt = args['createdAt'] as DateTime?;

    print("This is QR Data ${qrData}");
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

  void _calculateRemainingTime() {
    if (state.createdAt == null) {
      // New payment, use configured timeout
      log(
        '🆕 New payment session - starting with $_paymentTimeoutSeconds seconds',
      );
      updateState(
        (state) => state.copyWith(remainingSeconds: _paymentTimeoutSeconds),
      );
      return;
    }

    // Calculate elapsed time since payment was created
    final now = DateTime.now();
    final elapsed = now.difference(state.createdAt!);
    final elapsedSeconds = elapsed.inSeconds;

    // Calculate remaining time using configured timeout
    final remaining = _paymentTimeoutSeconds - elapsedSeconds;

    if (remaining <= 0) {
      // Payment already expired
      updateState(
        (state) => state.copyWith(remainingSeconds: 0, isExpired: true),
      );
    } else {
      // Update with actual remaining time
      updateState((state) => state.copyWith(remainingSeconds: remaining));
    }
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

    final body = VerifyPaymentBody(md5: state.md5);

    final result = await _bookingRepo.verifyMd5(
      body: body,
      bookingId: state.bookingId.toString(),
    );

    switch (result) {
      case Success<VerifyPaymentModel>():
        {
          final alreadyPaid = result.data.done;
          // if (payment?.payment?.status == BakongPaymentStatusEnum.paid.status) {
          if (alreadyPaid == true) {
            // Mark as paid immediately to prevent duplicate calls
            updateState((state) => state.copyWith(isPaid: true));

            // Stop timers immediately
            _stopVerificationPolling();
            _stopCountdownTimer();

            // Clear pending payment from Hive && Clear Md5
            await _hiveManager.clearPendingPayment();
            _clearLocalMd5();

            // Show success notification
            _showPaymentSuccessNotification();

            // Navigate immediately to success page
            _handlePaymentSuccess();
          }
        }
      case Error<VerifyPaymentModel>():
        {
          // Show error only on first few attempts to avoid spam
          if (_retryCount <= 3) {
            _showError(result.error.displayMessage);
          }
        }
    }
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
  }

  void _stopCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  void _stopVerificationPolling() {
    _verificationTimer?.cancel();
    _verificationTimer = null;
  }

  // MARK: API Cancel Booking
  void cancelBooking() async {
    if (state.bookingId == 0) return;

    updateState((state) => state.copyWith(isLoading: true));

    final result = await _bookingRepo.cancelBooking(bookingId: state.bookingId);

    switch (result) {
      case Success<void>():
        {
          updateState((state) => state.copyWith(isLoading: false));
          _clearLocalMd5();
          await _hiveManager.clearPendingPayment();
          Get.offAllNamed(AppRoutes.mainNavigation);
        }
      case Error<void>():
        {
          updateState((state) => state.copyWith(isLoading: false));
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

  bool isLowTime() => state.remainingSeconds <= 30;

  void _showError(String message) {
    // Use WidgetsBinding to ensure we're in the right context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        if (Get.isSnackbarOpen == true) {
          Get.closeAllSnackbars();
        }

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
    });
  }

  // MARK - Get Local MD5
  void _getLocalMd5() async {
    final md5 = _localRepository.getMD5();
    updateState((state) => state.copyWith(md5: md5));
  }

  void _clearLocalMd5() async => await _localRepository.removeMD5();

  @override
  void onClose() {
    _stopCountdownTimer();
    _stopVerificationPolling();
    super.onClose();
  }
}
