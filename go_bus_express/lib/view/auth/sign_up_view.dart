import 'package:flutter/material.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/xwidget/ButtonComponent.dart';
import 'package:shared_package/design_system/xwidget/TextComponent.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(XPadding.extralarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
            SizedBox(height: XPadding.small),
            Text(
              'Fill your inform below or register with your\nsocial account',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: XPadding.extralarge * 2),

            // Username field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(XPadding.large),
                ),
              ),
            ),
            SizedBox(height: XPadding.large),

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
            SizedBox(height: XPadding.large),

            // Password field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(XPadding.large),
                ),
              ),
            ),
            SizedBox(height: XPadding.medium),

            // Remember me checkbox
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  },
                  activeColor: goBusPrimary,
                ),
                Text(
                  'Remember me',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
            SizedBox(height: XPadding.large),

            // Sign up button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: goBusPrimary,
                  padding: EdgeInsets.symmetric(vertical: XPadding.large),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: white,
                  ),
                ),
              ),
            ),
            SizedBox(height: XPadding.extralarge),

            // Divider
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
            ),
            SizedBox(height: XPadding.extralarge),

            // Social login buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(
                  icon: Icons.facebook,
                  color: Color(0xFF1877F2),
                  onTap: () {},
                ),
                SizedBox(width: XPadding.large),
                _buildSocialButton(
                  icon: Icons.g_mobiledata,
                  color: Color(0xFFDB4437),
                  onTap: () {},
                ),
                SizedBox(width: XPadding.large),
                _buildSocialButton(
                  icon: Icons.apple,
                  color: black,
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: XPadding.extralarge),

            // Sign in link
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Sign In',
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
    );
  }

  Widget _buildSocialButton({
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
  }
}
