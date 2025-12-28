import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';

void xNoConnectionSnackBar() {
  if (Get.isSnackbarOpen != true) {
    Get.showSnackbar(
      GetSnackBar(
        title: 'No Internet Connection'.tr,
        message: 'Please check your internet connection and try again'.tr,
        icon: const Icon(Icons.wifi_off, color: Colors.white),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(XPadding.large),
        borderRadius: 8,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
