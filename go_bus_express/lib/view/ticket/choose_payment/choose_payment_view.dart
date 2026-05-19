import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/payment/choose_payment_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/AppImage.dart';
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

  final RxString _selectedPayment = 'KHQR'.obs;

  @override
  void initState() {
    super.initState();
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
        final selected = _selectedPayment.value;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(XPadding.extralarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Trip Summary ──────────────────────────────────────
                XTextLarge(
                  label: 'Trip Summary'.tr,
                  colortext: black,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: XPadding.large),

                _buildSummaryCard(state),

                SizedBox(height: XPadding.extralarge),

                // ── Payment Methods ───────────────────────────────────
                XTextLarge(
                  label: 'Choose Payment Method'.tr,
                  colortext: black,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: XPadding.large),

                _buildKhqrOption(selected),
                SizedBox(height: XPadding.medium),
                _buildWalletOption(
                  selected,
                  state.totalPrice,
                  state.walletBalance,
                ),
                SizedBox(height: XPadding.medium),

                // ── Terms ─────────────────────────────────────────────
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
        final selected = _selectedPayment.value;
        final walletBlocked =
            selected == 'Wallet' &&
            (state.walletBalance ?? 0.0) < state.totalPrice;
        final canProceed = controller.canProceedToPayment() && !walletBlocked;

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
              optionbutton: 1,
              bgColor: canProceed ? goBusPrimary : Colors.grey,
              onTap: canProceed
                  ? () => controller.createBooking(paymentMethod: selected)
                  : null,
            ),
          ),
        );
      }),
    );
  }

  // ── Trip Summary card ──────────────────────────────────────────────────────

  Widget _buildSummaryCard(dynamic state) {
    return Container(
      padding: EdgeInsets.all(XPadding.large),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Route header with direction + date
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: goBusPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.directions_bus_rounded,
                  color: goBusPrimary,
                  size: 22,
                ),
              ),
              SizedBox(width: XPadding.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    XTextMedium(
                      label: state.direction,
                      colortext: black,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 2),
                    XTextSmall(
                      label: state.formattedDepartureDate,
                      colortext: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: XPadding.medium),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),

          // Detail rows
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
            '- \$${state.discount.toStringAsFixed(2)}',
            valueColor: state.discount > 0 ? success : null,
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: XPadding.medium),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),

          // Net price highlight row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              XTextMedium(
                label: 'Net Price'.tr,
                colortext: black,
                fontWeight: FontWeight.bold,
              ),
              XTextLarge(
                label: '\$${state.totalPrice.toStringAsFixed(2)}',
                colortext: goBusPrimary,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── KHQR card ──────────────────────────────────────────────────────────────

  Widget _buildKhqrOption(String selected) {
    final isSelected = selected == 'KHQR';
    return _PaymentCard(
      isSelected: isSelected,
      onTap: () => _selectedPayment.value = 'KHQR',
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(AppImages.imgBakong, width: 40, height: 40),
      ),
      title: 'KHQR',
      subtitle: 'Scan to pay with any banking'.tr,
    );
  }

  // ── Wallet card ────────────────────────────────────────────────────────────

  Widget _buildWalletOption(
    String selected,
    double totalPrice,
    double? walletBalance,
  ) {
    final isSelected = selected == 'Wallet';
    final balance = walletBalance ?? 0.0;
    final hasSufficient = balance >= totalPrice;

    return GestureDetector(
      onTap: () => _selectedPayment.value = 'Wallet',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(XPadding.large),
        decoration: BoxDecoration(
          color: isSelected ? thinblue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? goBusPrimary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Wallet icon
                AppSvgImage(
                  path: AppImages.icWallet,
                  height: 40,
                  width: 40,
                  color: goBusPrimary,
                ),
                SizedBox(width: XPadding.large),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      XTextMedium(
                        label: 'wallet'.tr,
                        colortext: black,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      XTextSmall(
                        label: 'pay_instantly_with_your_balance'.tr,
                        colortext: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
                _RadioDot(isSelected: isSelected),
              ],
            ),
            SizedBox(height: XPadding.medium),

            // Balance strip
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: XPadding.large,
                vertical: XPadding.medium,
              ),
              decoration: BoxDecoration(
                color: hasSufficient
                    ? success.withOpacity(0.08)
                    : errorPrimary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    hasSufficient
                        ? Icons.check_circle_outline_rounded
                        : Icons.warning_amber_rounded,
                    size: 16,
                    color: hasSufficient ? success : errorPrimary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: XTextSmall(
                      label: hasSufficient
                          ? 'available_balance_custom'.trParams({
                              'balance': balance.toStringAsFixed(2),
                            })
                          : 'insufficient_balance_custom'.trParams({
                              'balance': balance.toStringAsFixed(2),
                            }),
                      colortext: hasSufficient ? success : errorPrimary,
                    ),
                  ),
                  if (!hasSufficient)
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.topUpWallet),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: goBusPrimary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: XTextSmall(label: 'top_up'.tr, colortext: white),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        XTextMedium(
          label: label,
          colortext: Colors.grey.shade600,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
        SizedBox(width: XPadding.medium),
        Flexible(
          child: XTextMedium(
            label: value,
            colortext: valueColor ?? black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Reusable payment card (for KHQR) ─────────────────────────────────────────

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.isSelected,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(XPadding.large),
        decoration: BoxDecoration(
          color: isSelected ? thinblue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? goBusPrimary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            leading,
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
                  const SizedBox(height: 4),
                  XTextSmall(label: subtitle, colortext: Colors.grey.shade600),
                ],
              ),
            ),
            _RadioDot(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

// ── Radio indicator dot ───────────────────────────────────────────────────────

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.isSelected});
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? goBusPrimary : Colors.transparent,
        border: Border.all(
          color: isSelected ? goBusPrimary : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}
