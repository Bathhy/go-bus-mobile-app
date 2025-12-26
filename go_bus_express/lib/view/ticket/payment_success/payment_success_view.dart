import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/x_widget/TextComponent.dart';

import '../../../utils/enums/lotties_enum.dart';

class PaymentSuccessView extends StatefulWidget {
  const PaymentSuccessView({super.key});

  @override
  State<PaymentSuccessView> createState() => _PaymentSuccessViewState();
}

class _PaymentSuccessViewState extends State<PaymentSuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final bookingId = args?['bookingId'] ?? 0;
    final amount = args?['amount'] ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(), // pushes content down
              /// CENTER CONTENT
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.network(
                    LottieConstant.paymentSuccess.url,
                    width: 250,
                    height: 250,
                    controller: _lottieController,
                    repeat: false,
                    onLoaded: (composition) {
                      _lottieController
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),

                  const SizedBox(height: 32),

                   Text(
                    'Payment was successful'.tr,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                   Text(
                    'Thanks for riding with us. Have a great trip!'.tr,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.mainNavigation);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goBusPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: XTextLarge(label: "Go To HomePage".tr, colortext: white),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
