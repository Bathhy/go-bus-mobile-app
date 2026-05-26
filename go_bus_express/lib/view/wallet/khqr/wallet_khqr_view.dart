import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/view/widget/x_loading_dialog.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_khqr_controller.dart';
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';

class WalletKhQrView extends StatefulWidget {
  const WalletKhQrView({super.key});

  @override
  State<WalletKhQrView> createState() => _WalletKhQrViewState();
}

class _WalletKhQrViewState extends State<WalletKhQrView> {
  final controller = getIt<WalletKhQrController>();
  Worker? _stateWorker;
  static const _platform = MethodChannel('com.gobus.express/security');

  // Prevents two dialogs stacking on top of each other
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
  }

  Future<void> _disableScreenshots() async {
    try {
      await _platform.invokeMethod('disableScreenshots');
    } catch (e) {
      debugPrint('Failed to disable screenshots: $e');
    }
  }

  Future<void> _enableScreenshots() async {
    try {
      await _platform.invokeMethod('enableScreenshots');
    } catch (e) {
      debugPrint('Failed to enable screenshots: $e');
    }
  }

  @override
  void dispose() {
    _enableScreenshots();
    _stateWorker?.dispose();
    super.dispose();
  }

  // ── Cancel Dialog ──────────────────────────────────────────────────────────

  void _showCancelDialog() {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
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

              // Title
              Text(
                'cancel_topup_title'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                'cancel_topup_message'.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Buttons
              Row(
                children: [
                  // Keep Waiting (primary)
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goBusPrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'keep_waiting'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Cancel Top-Up (destructive)
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back(); // close dialog first
                          controller.cancelTopUp();
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
                          'cancel_topup'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
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

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: shimerBgColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: XAppBar(
            title: 'Top Up'.tr,
            onBackPressed: () => _showCancelDialog(),
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

                if (state.isGenerating)
                  const CircularProgressIndicator()
                else if (state.qrData.isEmpty)
                  const SizedBox.shrink()
                else
                  KhqrCardWidget(
                    qr: state.qrData,
                    width: 300.0,
                    receiverName: 'Go-Bus Express'.tr,
                    amount: state.amount,
                    keepIntegerDecimal: false,
                    currency: KhqrCurrency.usd,
                  ),

                Text(
                  'Scan to top up your wallet'.tr,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Amount: '.tr,
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
