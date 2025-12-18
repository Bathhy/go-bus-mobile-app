import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/view_models/controller/payment/kh_qr/kh_qr_controller.dart';
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';

class KHQRPaymentView extends StatefulWidget {
  const KHQRPaymentView({super.key});

  @override
  State<KHQRPaymentView> createState() => _KHQRPaymentViewState();
}

class _KHQRPaymentViewState extends State<KHQRPaymentView> {
  final controller = getIt<KhQrController>();

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Payment Timeout'),
        content: Text('Your payment session has expired.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: shimerBgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final state = controller.state;

          // Show timeout dialog when expired
          if (state.isExpired) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showTimeoutDialog();
            });
          }

          return Column(
            children: [
              XAppBar(
                title: 'Make Payment',
                onBackPressed: () => Navigator.of(context).pop(),
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
                CircularProgressIndicator()
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
              const Text(
                'Scan to pay with any banking',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              // SubTotal
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'SubTotal: ',
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
    );
  }
}
