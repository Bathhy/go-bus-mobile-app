import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/utils/enums/lotties_enum.dart';
import 'package:go_bus_express/view_models/controller/splash/SplashController.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_package/config/themes.dart';

import '../../core/di/app_di.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _EasyAnimationState createState() => _EasyAnimationState();
}

class _EasyAnimationState extends State<SplashView> {
  final SplashController _splashController = getIt<SplashController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 8), () {
      if (_splashController.isLoggedIn.value) {
        Get.offAllNamed(AppRoutes.mainNavigation);
      } else {
        Get.offAllNamed(AppRoutes.signIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Lottie.network(
          LottieConstant.goBus.url,
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
