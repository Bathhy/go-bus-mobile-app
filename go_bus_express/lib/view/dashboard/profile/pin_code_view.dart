import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/ButtonComponent.dart';
import 'package:shared_package/design_system/x_widget/TextComponent.dart';

class PinCodeView extends StatefulWidget {
  const PinCodeView({super.key});

  @override
  State<PinCodeView> createState() => _PinCodeViewState();
}

class _PinCodeViewState extends State<PinCodeView> {
  String pinCode = '';
  final int pinLength = 4;
  bool isError = false;

  void _onNumberTap(String number) {
    if (pinCode.length < pinLength) {
      setState(() {
        pinCode += number;
        isError = false;
      });

      if (pinCode.length == pinLength) {
        _verifyPin();
      }
    }
  }

  void _onDeleteTap() {
    if (pinCode.isNotEmpty) {
      setState(() {
        pinCode = pinCode.substring(0, pinCode.length - 1);
        isError = false;
      });
    }
  }

  void _verifyPin() {
    // TODO: Implement actual PIN verification logic
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        isError = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          pinCode = '';
          isError = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBgColor,
      appBar: AppBar(
        backgroundColor: primaryBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: XTextLarge(
          label: 'Enter PIN Code'.tr,
          colortext: black,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lock Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: goBusPrimary.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 40,
                      color: goBusPrimary,
                    ),
                  ),

                  SizedBox(height: XPadding.extralarge),

                  // Title
                  XTextLarge(
                    label: 'Enter Your PIN'.tr,
                    colortext: black,
                    fontWeight: FontWeight.bold,
                  ),

                  SizedBox(height: XPadding.medium),

                  // Subtitle
                  Text(
                    'Please enter your 4-digit PIN code'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: XPadding.extralarge * 2),

                  // PIN Dots
                  _buildPinDots(),

                  if (isError) ...[
                    SizedBox(height: XPadding.large),
                    Text(
                      'Incorrect PIN. Please try again.'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: errorPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Number Pad
            _buildNumberPad(),

            SizedBox(height: XPadding.extralarge),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pinLength,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: XPadding.medium),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < pinCode.length
                ? (isError ? errorPrimary : goBusPrimary)
                : Colors.grey[300],
            border: Border.all(
              color: index < pinCode.length
                  ? (isError ? errorPrimary : goBusPrimary)
                  : Colors.grey[400]!,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
      child: Column(
        children: [
          _buildNumberRow(['1', '2', '3']),
          SizedBox(height: XPadding.large),
          _buildNumberRow(['4', '5', '6']),
          SizedBox(height: XPadding.large),
          _buildNumberRow(['7', '8', '9']),
          SizedBox(height: XPadding.large),
          _buildNumberRow(['', '0', 'delete']),
        ],
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        if (number.isEmpty) {
          return const SizedBox(width: 70, height: 70);
        }

        if (number == 'delete') {
          return _buildNumberButton(
            child: Icon(
              Icons.backspace_outlined,
              color: Colors.black87,
              size: 28,
            ),
            onTap: _onDeleteTap,
          );
        }

        return _buildNumberButton(
          child: XTextLarge(
            label: number,
            colortext: black,
            fontWeight: FontWeight.w600,
          ),
          onTap: () => _onNumberTap(number),
        );
      }).toList(),
    );
  }

  Widget _buildNumberButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
