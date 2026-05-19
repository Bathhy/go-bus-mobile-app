import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/view_models/controller/payment/kh_qr/kh_qr_controller.dart';
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';

import '../../widget/x_loading_dialog.dart';

class KHQRPaymentView extends StatefulWidget {
  const KHQRPaymentView({super.key});

  @override
  State<KHQRPaymentView> createState() => _KHQRPaymentViewState();
}

class _KHQRPaymentViewState extends State<KHQRPaymentView> {
  final controller = getIt<KhQrController>();
  Worker? _stateWorker;
  Worker? _errorWorker;
  static const platform = MethodChannel('com.gobus.express/security');

  // Prevents two dialogs from stacking (cancel dialog + error dialog)
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _disableScreenshots();

    _stateWorker = ever(controller.obs, (state) {
      if (state.isLoading) {
        XAppLoadingDialog.showAppDialog();
      } else {
        XAppLoadingDialog.hideAppDialog();
      }
    });

    _errorWorker = ever(controller.paymentError, (error) {
      if (error != null && mounted) {
        controller.paymentError.value = null;
        // Dismiss any open dialog (e.g. cancel dialog) before showing error
        if (_isDialogShowing) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        _showPaymentErrorDialog(error);
      }
    });
  }

  Future<void> _disableScreenshots() async {
    try {
      await platform.invokeMethod('disableScreenshots');
    } catch (e) {
      debugPrint('Failed to disable screenshots: $e');
    }
  }

  Future<void> _enableScreenshots() async {
    try {
      await platform.invokeMethod('enableScreenshots');
    } catch (e) {
      debugPrint('Failed to enable screenshots: $e');
    }
  }

  @override
  void dispose() {
    _enableScreenshots();
    _stateWorker?.dispose();
    _errorWorker?.dispose();
    super.dispose();
  }

  // MARK: - Cancel Payment Dialog

  void _showCancelPaymentDialog() {
    if (_isDialogShowing) return;
    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 48,
                  color: Colors.orange.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Cancel Payment?'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to leave?\nYour booking will be cancelled.'
                    .tr,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          controller.cancelBooking();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'ok'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((_) => _isDialogShowing = false);
  }

  // MARK: - Payment Error Dialog

  void _showPaymentErrorDialog(String errorType) {
    _isDialogShowing = true;
    final isPending = errorType == 'pending';

    final IconData icon = isPending ? Icons.hourglass_top_rounded : Icons.error_outline_rounded;
    final Color iconBgColor = isPending ? Colors.blue.shade50 : Colors.red.shade50;
    final Color iconColor = isPending ? Colors.blue.shade400 : Colors.red.shade400;

    final String title = isPending
        ? 'payment_pending'.tr
        : 'payment_not_completed'.tr;

    final String message = switch (errorType) {
      'pending' => 'payment_pending_message'.tr,
      'error'   => 'payment_error_message'.tr,
      _         => 'payment_failed_message'.tr,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: iconColor),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Buttons
              Column(
                children: [
                  // Try Again (primary)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.retryPayment();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'try_again'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel Booking (secondary)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        controller.cancelBooking();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                        side: BorderSide(
                          color: Colors.red.shade300,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'cancel_booking'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((_) => _isDialogShowing = false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: shimerBgColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: XAppBar(
            title: 'Payment'.tr,
            onBackPressed: () => _showCancelPaymentDialog(),
          ),
        ),
        body: Obx(() {
          final state = controller.state;

          return SafeArea(
            child: Column(
              spacing: XPadding.extralarge,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  color: white,
                  child: Image.asset(AppImages.imgBus),
                ),
                SizedBox(height: XPadding.medium),

                // Show loading or QR code
                if (state.qrData.isEmpty)
                  const CircularProgressIndicator()
                else
                  KhqrCardWidget(
                    qr: state.qrData,
                    width: 300.0,
                    receiverName: state.receiverName,
                    amount: state.amount,
                    keepIntegerDecimal: false,
                    currency: state.currency == 'USD'
                        ? KhqrCurrency.usd
                        : KhqrCurrency.khr,
                  ),

                // Instructions
                Text(
                  'Scan to pay with any banking'.tr,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),

                // SubTotal
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'SubTotal: '.tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '\$${state.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        }),
      ),
    );
  }
}
