import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Safe navigation helper that bypasses GetX's snackbar queue entirely.
///
/// Never call [Get.back] / [Get.closeAllSnackbars] / [Get.closeCurrentSnackbar]
/// here — all three internally access [SnackbarController._controller] which is
/// a `late AnimationController` only initialised once the snackbar widget mounts.
/// Calling them while a [Get.snackbar] job is queued but not yet mounted throws
/// a [LateInitializationError].  Using [Navigator.pop] directly bypasses that
/// queue completely.
class NavigationHelper {
  /// Pop the current route using plain [Navigator.pop], which does not touch
  /// GetX's internal snackbar queue.
  static void safeBack({dynamic result}) {
    final ctx = Get.context;
    if (ctx == null) return;
    if (Navigator.canPop(ctx)) {
      Navigator.of(ctx).pop(result);
    }
  }
}
