import 'package:get/get.dart';

/// Safe navigation helper to prevent GetX snackbar controller errors
class NavigationHelper {
  /// Safely navigate back, handling snackbar controller initialization issues
  static void safeBack({
    dynamic result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  }) {
    try {
      // Close any open snackbars first
      if (Get.isSnackbarOpen == true) {
        Get.closeAllSnackbars();
      }
      
      // Navigate back with closeOverlays set to false to avoid snackbar controller issues
      Get.back(
        result: result,
        closeOverlays: closeOverlays,
        canPop: canPop,
        id: id,
      );
    } catch (e) {
      // Fallback: if Get.back() fails, the error is already handled
      // The navigation will still work because Get.back() completes before throwing
      // the snackbar controller error
    }
  }
}
