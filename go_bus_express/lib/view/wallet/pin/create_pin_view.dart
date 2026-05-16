import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/view/wallet/pin/wallet_pin_scaffold.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_controller.dart';

class CreatePinView extends StatelessWidget {
  const CreatePinView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<WalletController>();
    return WalletPinScaffold(
      title: 'Create Wallet PIN'.tr,
      subtitle: 'Set a 4-digit PIN to secure your wallet'.tr,
      onPinComplete: controller.setTempPin,
    );
  }
}
