import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_package/config/themes.dart';

class XAppLoadingDialog {
  static void showAppDialog() {
    if (Get.isDialogOpen != true) {
      Get.dialog(
        PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
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
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}
