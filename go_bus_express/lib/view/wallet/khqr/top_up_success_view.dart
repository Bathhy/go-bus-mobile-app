import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_package/config/themes.dart';

import '../../../utils/enums/lotties_enum.dart';

class TopUpSuccessView extends StatefulWidget {
  const TopUpSuccessView({super.key});

  @override
  State<TopUpSuccessView> createState() => _TopUpSuccessViewState();
}

class _TopUpSuccessViewState extends State<TopUpSuccessView>
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),

                /// Center content
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
                      'topup_success_title'.tr,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'topup_success_message'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Get.until(
                      (route) => route.settings.name == AppRoutes.wallet,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goBusPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'go_back'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
