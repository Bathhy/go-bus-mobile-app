import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/view/widget/x_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    _stateWorker = ever(controller.obs, (state) {
      if (state.isLoading) {
        XAppLoadingDialog.showAppDialog();
      } else {
        XAppLoadingDialog.hideAppDialog();
      }
    });
  }

  @override
  void dispose() {
    _stateWorker?.dispose();
    super.dispose();
  }

  void _showCancelPaymentDialog() {
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
              // Icon Container
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
                'Cancel Payment?'.tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
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
                        onPressed: () {
                          Get.back();
                        },
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

                  // Cancel Booking Button
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: shimerBgColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(() {
            final state = controller.state;

            // Show timeout dialog when expired
            if (state.isExpired) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                XDialog.showTimeoutDialog(
                  context,
                  () => controller.cancelBooking(),
                );
              });
            }

            return Column(
              children: [
                XAppBar(
                  title: 'Payment'.tr,
                  onBackPressed: () => _showCancelPaymentDialog(),
                  actions: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: XPadding.medium,
                        horizontal: XPadding.small,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(XPadding.medium),
                        ),
                        color: controller.isLowTime()
                            ? Colors.red.shade100
                            : Colors.orange.shade100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: controller.isLowTime()
                                ? Colors.red
                                : Colors.orange,
                            size: 20,
                          ),
                          SizedBox(width: XPadding.small),
                          Text(
                            controller.formatTime(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: controller.isLowTime()
                                  ? Colors.red.shade900
                                  : Colors.orange.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: XPadding.extralarge),
                  ],
                ),
              ],
            );
          }),
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
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                // SubTotal
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'SubTotal: '.tr,
                        style: TextStyle(
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
