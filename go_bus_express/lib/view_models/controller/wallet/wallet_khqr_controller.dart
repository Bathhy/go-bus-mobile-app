import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/models/payment/verify_payment_model.dart';
import 'package:go_bus_express/models/wallet/wallet_topup_khqr_model.dart';
import 'package:go_bus_express/repository/wallet_repository.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_controller.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_khqr_state.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/network/base_response.dart';
import 'package:shared_package/network/x_result.dart';

class WalletKhQrController extends BaseController<WalletKhQrState> {
  final WalletRepository _walletRepo;

  WalletKhQrController(this._walletRepo) : super(const WalletKhQrState());

  @override
  void onInit() {
    super.onInit();
    _initFromArgs();
    _generateAndVerify();
  }

  void _initFromArgs() {
    final args = Get.arguments as Map<String, dynamic>?;
    final amount = (args?['amount'] as num?)?.toDouble() ?? 0.0;
    updateState((s) => s.copyWith(amount: amount));
  }

  void _generateAndVerify() async {
    final token = _sessionToken;
    if (token.isEmpty) {
      _showError('Wallet session expired. Please log in again.');
      return;
    }

    updateState((s) => s.copyWith(isGenerating: true));

    final result = await _walletRepo.generateTopUpKhqr(
      sessionToken: token,
      amount: state.amount,
    );

    switch (result) {
      case Success<WalletTopUpKhqrModel?>():
        final qr = result.data?.data?.qr ?? '';
        final md5 = result.data?.data?.md5 ?? '';
        updateState((s) => s.copyWith(qrData: qr, md5: md5, isGenerating: false));
        if (qr.isNotEmpty && md5.isNotEmpty) {
          _checkTopUpTransaction(token);
        }
      case Error<WalletTopUpKhqrModel?>():
        updateState((s) => s.copyWith(isGenerating: false));
        _showError(result.error.displayMessage);
    }
  }

  void _checkTopUpTransaction(String token) async {
    log('🔄 Waiting for top-up payment confirmation...');

    final result = await _walletRepo.checkTopUpTransaction(
      sessionToken: token,
      md5: state.md5,
    );

    switch (result) {
      case Success<BaseResponse<VerifyPaymentModel>>():
        if (result.data.status == 200) {
          updateState((s) => s.copyWith(isPaid: true));
          await _refreshWalletBalance();
          Get.offNamedUntil(
            AppRoutes.wallet,
            ModalRoute.withName(AppRoutes.mainNavigation),
          );
        } else {
          log('⚠️ Top-up not completed yet');
        }
      case Error<BaseResponse<VerifyPaymentModel>>():
        _showError(result.error.displayMessage);
    }
  }

  Future<void> _refreshWalletBalance() async {
    try {
      await getIt<WalletController>().fetchWalletMe();
    } catch (e) {
      log('⚠️ Could not refresh wallet balance: $e');
    }
  }

  String get _sessionToken =>
      getIt<WalletController>().state.wallet?.walletSessionToken ?? '';

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).clearSnackBars();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error'.tr,
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(message, style: const TextStyle(color: white)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }
}
