import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/view/wallet/pin/wallet_pin_scaffold.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_controller.dart';

class EnterPinView extends StatelessWidget {
  const EnterPinView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<WalletController>();
    return Obx(
      () => WalletPinScaffold(
        title: 'Wallet PIN'.tr,
        subtitle: 'Enter your PIN to access your wallet'.tr,
        isLoading: controller.state.isLoading,
        errorMessage: controller.state.errorMessage,
        onPinComplete: controller.loginWallet,
        onErrorCleared: controller.clearError,
      ),
    );
  }
}
