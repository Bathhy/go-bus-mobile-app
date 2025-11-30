import 'package:flutter/material.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
          "https://lottie.host/6370ec08-1f68-43dd-8484-4723c395627c/oM8FjhaHyd.json",
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
