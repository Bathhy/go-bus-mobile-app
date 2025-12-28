import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/view/widget/x_no_connection_snack_bar.dart';

class ConnectivityService extends GetxService {
  Timer? _connectivityTimer;

  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _startMonitoring();
  }

  void _startMonitoring() {
    // Check connectivity every 3 seconds
    _connectivityTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkConnectivity(),
    );

    // Initial check
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final wasConnected = isConnected.value;

    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));

      isConnected.value = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isConnected.value = false;
    } catch (_) {
      // Keep previous state if check fails
    }

    // Show snackbar when connection status changes
    if (wasConnected && !isConnected.value) {
      xNoConnectionSnackBar();
    }
  }

  @override
  void onClose() {
    _connectivityTimer?.cancel();
    super.onClose();
  }
}
