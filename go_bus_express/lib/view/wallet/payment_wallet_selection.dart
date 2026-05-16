import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';

class PaymentWalletSelectionView extends StatefulWidget {
  const PaymentWalletSelectionView({super.key});

  @override
  State<PaymentWalletSelectionView> createState() =>
      _PaymentWalletSelectionViewState();
}

class _PaymentWalletSelectionViewState
    extends State<PaymentWalletSelectionView> {
  static const String _bakongMethod = 'bakong';
  String _selectedMethod = _bakongMethod;

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final usdAmount = (args?['usdAmount'] as num?)?.toDouble() ?? 25.00;
    final khrAmount = (args?['khrAmount'] as num?)?.toInt() ?? 100000;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: goBusPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'payment_selection_title'.tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF171C24),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(XPadding.extralarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildAmountSummaryCard(usdAmount, khrAmount),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'select_payment_method'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF141922),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: goBusPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'one_option_available'.tr,
                            style: TextStyle(
                              fontSize: 11,
                              color: goBusPrimary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentCard(),
                    const SizedBox(height: 14),
                    _buildInfoCard(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                XPadding.extralarge,
                12,
                XPadding.extralarge,
                XPadding.extralarge,
              ),
              child: _buildConfirmButton(usdAmount),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSummaryCard(double usdAmount, int khrAmount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E8EE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'total_payment'.tr,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: Color(0xFF8D94A0),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${usdAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 38,
              height: 1,
              color: goBusPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6FB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '≈ ${_formatKhr(khrAmount)} KHR',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8D94A0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    final isSelected = _selectedMethod == _bakongMethod;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = _bakongMethod),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? goBusPrimary : const Color(0xFFE5E8EE),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: goBusPrimary.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                AppImages.imgBakong,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bakong'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF151A21),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'bakong_payment_subtitle'.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8D94A0),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? goBusPrimary : const Color(0xFFE5E8EE),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: isSelected ? 16 : 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0E4F7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: goBusPrimary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.info_outline, color: goBusPrimary, size: 15),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'bakong_info_message'.tr,
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Color(0xFF4F5662),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(double usdAmount) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: goBusPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          Get.toNamed(
            AppRoutes.walletTopUpKhqr,
            arguments: {'amount': usdAmount},
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'confirm_payment'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 22),
          ],
        ),
      ),
    );
  }

  String _formatKhr(int value) {
    final text = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }
}
