import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/auth/AuthController.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  // final TextEditingController emailController = TextEditingController(text: "panha@gmail.com");
  // final TextEditingController emailController = TextEditingController(text: "natsu@gmail.com");
  // final TextEditingController passwordController = TextEditingController(text: "Sambath1302@");
    final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");
  //   final TextEditingController emailController = TextEditingController(text: "thongVathana@gmail.col\\       m");
  // final TextEditingController passwordController = TextEditingController(text: "Vathana@123");
  final AuthController authController = getIt<AuthController>();
  bool rememberMe = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(backgroundColor: white, elevation: 0),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(XPadding.extralarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
              SizedBox(height: XPadding.small),
              Text(
                'Hi! Welcome Go Bus Express',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              SizedBox(height: XPadding.extralarge * 2),

              // Email field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(XPadding.large),
                  ),
                ),
              ),
              SizedBox(height: XPadding.extralarge),

              // Password field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(XPadding.large),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Sign in button
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authController.state.isLoading
                        ? null
                        : _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goBusPrimary,
                      padding: EdgeInsets.symmetric(vertical: XPadding.large),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: authController.state.isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: white,
                      ),
                    ),
                  ),
                ),
              ),
             /* SizedBox(height: XPadding.extralarge),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: XPadding.medium),
                    child: Text(
                      'or continue with',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),*/
              SizedBox(height: 50),
            /*  // Social login buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    color: Color(0xFFDB4437),
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: XPadding.extralarge),
*/
              // Sign up link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      onTap: () {Get.toNamed(AppRoutes.signUp);},
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: goBusPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignIn() {
    authController.login(emailController.text.trim(), passwordController.text);
  }

 /* Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }*/
}
