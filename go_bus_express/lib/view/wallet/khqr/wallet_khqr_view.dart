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
            onBackPressed: () => Get.back(),
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
