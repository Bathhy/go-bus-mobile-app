import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/utils/enums/lotties_enum.dart';
import 'package:go_bus_express/view/auth/sign_up_view.dart';
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
=======
import 'package:go_bus_express/view/auth/sign_up_view.dart';
import 'package:lottie/lottie.dart';
//import 'sign_up_view.dart';

class AnimationView extends StatefulWidget {
  AnimationView({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _EasyAnimationState createState() => _EasyAnimationState();
}

class _EasyAnimationState extends State<AnimationView> {
  @override
  void initState() {
    super.initState();

    // Go to Sign Up screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpView()),
      );
>>>>>>> 706acd1 (done)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: white,
      body: Center(
        child: Lottie.network(
          LottieConstant.goBus.url,
=======
      body: Center(
        child: Lottie.network(
          "https://lottie.host/6370ec08-1f68-43dd-8484-4723c395627c/oM8FjhaHyd.json",
>>>>>>> 706acd1 (done)
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
