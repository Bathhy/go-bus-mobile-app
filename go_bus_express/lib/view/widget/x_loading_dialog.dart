import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_package/config/themes.dart';

class XAppLoadingDialog {
  static bool _isShowing = false;

  static void showAppDialog() {
    if (!_isShowing && Get.isDialogOpen != true) {
      _isShowing = true;
      Get.dialog(
        PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(goBusPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void hideAppDialog() {
    if (_isShowing && Get.isDialogOpen == true) {
      _isShowing = false;
      try {
        Get.back();
      } catch (e) {
        // Ignore errors when closing dialog
        _isShowing = false;
      }
    }
  }
}
