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
            fontSize: 20,
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
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'total_payment'.tr,
                            style: const TextStyle(
                              fontSize: 19,
                              color: Color(0xFF3D4452),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${usdAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 58,
                              height: 1,
                              color: goBusPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_formatKhr(khrAmount)} KHR',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFF8D94A0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 38),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'select_payment_method'.tr,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF141922),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: goBusPrimary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'one_option_available'.tr,
                            style: TextStyle(
                              fontSize: 11,
                              color: goBusPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildPaymentCard(),
                    const SizedBox(height: 18),
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
              child: _buildConfirmButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard() {
    final isSelected = _selectedMethod == _bakongMethod;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = _bakongMethod;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? goBusPrimary : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                AppImages.imgBakong,
                width: 68,
                height: 68,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bakong'.tr,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF151A21),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'bakong_payment_subtitle'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4E5563),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? goBusPrimary : Colors.grey.shade300,
              ),
              child: Icon(
                isSelected ? Icons.check : Icons.circle_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2535A8),
            ),
            child: const Icon(Icons.info, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'bakong_info_message'.tr,
              style: const TextStyle(
                fontSize: 15,
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

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
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
          Get.toNamed(AppRoutes.makePayment);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'confirm_payment'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.chevron_right_rounded, size: 30),
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
