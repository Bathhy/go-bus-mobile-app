import 'package:flutter/material.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(XPadding.extralarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),

              // Logo or illustration placeholder
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: goBusPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_bus,
                  size: 100,
                  color: goBusPrimary,
                ),
              ),
              SizedBox(height: XPadding.extralarge * 2),

              Text(
                'Welcome to GO-Bus',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
              SizedBox(height: XPadding.medium),
              Text(
                'Book your bus tickets easily',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),

              // Sign up button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to sign up
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goBusPrimary,
                    padding: EdgeInsets.symmetric(vertical: XPadding.large),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: XPadding.large),

              // Sign in button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to sign in
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: XPadding.large),
                    side: BorderSide(color: goBusPrimary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: goBusPrimary,
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
            ],
          ),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
}
