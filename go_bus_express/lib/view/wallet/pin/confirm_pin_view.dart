import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/view/wallet/pin/wallet_pin_scaffold.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_controller.dart';

class ConfirmPinView extends StatelessWidget {
  const ConfirmPinView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<WalletController>();
    return Obx(
      () => WalletPinScaffold(
        title: 'Confirm PIN'.tr,
        subtitle: 'Re-enter your PIN to confirm'.tr,
        isLoading: controller.state.isLoading,
        errorMessage: controller.state.errorMessage,
        onPinComplete: controller.createAndLogin,
        onErrorCleared: controller.clearError,
      ),
    );
  }
}
