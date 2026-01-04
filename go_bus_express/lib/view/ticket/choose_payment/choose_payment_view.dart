import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/payment/choose_payment_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/ButtonComponent.dart';
import 'package:shared_package/design_system/x_widget/TextComponent.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';

import '../../../core/di/app_di.dart';
import '../../widget/x_loading_dialog.dart';

class ChoosePaymentView extends StatefulWidget {
  const ChoosePaymentView({super.key});

  @override
  State<ChoosePaymentView> createState() => _ChoosePaymentViewState();
}

class _ChoosePaymentViewState extends State<ChoosePaymentView> {
  final ChoosePaymentController controller = getIt<ChoosePaymentController>();
  Worker? _stateWorker;

  @override
  void initState() {
    super.initState();
    // Listen to state changes using ever
    _stateWorker = ever(controller.obs, (state) {
      if (state.isLoading) {
        XAppLoadingDialog.showAppDialog();
      } else {
        XAppLoadingDialog.hideAppDialog();
      }
    });
  }

  @override
  void dispose() {
    _stateWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: XAppBar(
          title: 'Choose Payment'.tr,
          onBackPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Obx(() {
        final state = controller.state;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(XPadding.extralarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip Summary
                XTextLarge(
                  label: 'Trip Summary'.tr,
                  colortext: black,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: XPadding.large),

                _buildSummaryRow('Direction'.tr, state.direction),
                SizedBox(height: XPadding.medium),
                _buildSummaryRow('Departure Date'.tr, state.departureDate),
                SizedBox(height: XPadding.medium),
                _buildSummaryRow('Seat No'.tr, state.seatsDisplay),
                SizedBox(height: XPadding.medium),
                _buildSummaryRow(
                  'Unit Price'.tr,
                  '\$${state.unitPrice.toStringAsFixed(2)}',
                ),
                SizedBox(height: XPadding.medium),
                _buildSummaryRow('qty'.tr, '${state.quantity}'),
                SizedBox(height: XPadding.medium),
                _buildSummaryRow(
                  'Discount'.tr,
                  '\$${state.discount.toStringAsFixed(2)}',
                ),
                SizedBox(height: XPadding.medium),
                _buildSummaryRow(
                  'Net Price'.tr,
                  '\$${state.totalPrice.toStringAsFixed(2)}',
                  isBold: true,
                ),
                SizedBox(height: XPadding.extralarge),
                // Choose Payment Method
                XTextLarge(
                  label: 'Choose Payment Method'.tr,
                  colortext: black,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: XPadding.large),

                _buildPaymentOption(
                  'KHQR',
                  'KHQR',
                  'Scan to pay with any banking'.tr,
                  state.selectedPaymentMethod == 'KHQR',
                ),
                SizedBox(height: XPadding.medium),

                // Terms checkbox
                GestureDetector(
                  onTap: () => controller.toggleTermsAgreement(),
                  child: Row(
                    children: [
                      Checkbox(
                        value: state.agreedToTerms,
                        onChanged: (_) => controller.toggleTermsAgreement(),
                        activeColor: goBusPrimary,
                      ),
                      Expanded(
                        child: XTextMedium(
                          label: 'Term & Conditions Agreement'.tr,
                          colortext: black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: XPadding.extralarge),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final state = controller.state;
        final canProceed = controller.canProceedToPayment();

        return Container(
          padding: EdgeInsets.all(XPadding.extralarge),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: XButton(
              height: 52,
              label: 'Pay'.trParams({
                'amount': state.totalPrice.toStringAsFixed(2),
              }),
              optionbutton: canProceed ? 1 : 0,
              bgColor: canProceed ? goBusPrimary : Colors.grey,
              onTap: canProceed ? () => controller.createBooking() : null,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: XTextMedium(
            label: label,
            colortext: Colors.grey.shade700,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        XTextMedium(label: ':', colortext: Colors.grey.shade700),
        SizedBox(width: XPadding.medium),
        Expanded(
          child: XTextMedium(
            label: value,
            colortext: black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    String id,
    String title,
    String subtitle,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => controller.selectPaymentMethod(id),
      child: Container(
        padding: EdgeInsets.all(XPadding.large),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? goBusPrimary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                id == 'KHQR' ? AppImages.imgBakong : AppImages.imgBakong,
                width: 40,
                height: 40,
              ),
            ),
            SizedBox(width: XPadding.large),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  XTextMedium(
                    label: title,
                    colortext: black,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 4),
                  XTextSmall(label: subtitle, colortext: Colors.grey.shade600),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: goBusPrimary, size: 24),
          ],
        ),
      ),
    );
  }
}
