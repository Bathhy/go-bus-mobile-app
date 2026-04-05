import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/ButtonComponent.dart';
import 'package:shared_package/design_system/x_widget/TextComponent.dart';

class TopUpWalletView extends StatefulWidget {
  const TopUpWalletView({super.key});

  @override
  State<TopUpWalletView> createState() => _TopUpWalletViewState();
}

class _TopUpWalletViewState extends State<TopUpWalletView> {
  final TextEditingController _amountController = TextEditingController();
  double? selectedAmount;
  final List<double> quickAmounts = [10000, 20000, 50000, 100000, 200000, 500000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Top Up Wallet'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(XPadding.extralarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopUpCard(),
              const SizedBox(height: 24),
              XTextLarge(
                label: 'Quick Amount'.tr,
                colortext: black,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              _buildQuickAmountGrid(),
              const SizedBox(height: 24),
              XTextLarge(
                label: 'Custom Amount'.tr,
                colortext: black,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              _buildCustomAmountInput(),
              const SizedBox(height: 24),
              XTextLarge(
                label: 'Payment Method'.tr,
                colortext: black,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              _buildPaymentMethods(),
              const SizedBox(height: 32),
              _buildTopUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopUpCard() {
    return Container(
      padding: EdgeInsets.all(XPadding.extralarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            goBusPrimary.withOpacity(0.1),
            goBusPrimary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goBusPrimary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: goBusPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: goBusPrimary,
              size: 32,
            ),
          ),
          SizedBox(width: XPadding.large),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Balance'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '\$150,000.00',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmountGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: quickAmounts.length,
      itemBuilder: (context, index) {
        final amount = quickAmounts[index];
        final isSelected = selectedAmount == amount;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedAmount = amount;
              _amountController.clear();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? goBusPrimary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? goBusPrimary : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                '\$${amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            selectedAmount = null;
          });
        },
        decoration: InputDecoration(
          hintText: 'Enter amount'.tr,
          prefixIcon: Padding(
            padding: EdgeInsets.all(XPadding.large),
            child: Text(
              '\$',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(XPadding.large),
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        _buildPaymentMethodItem(
          icon: Icons.qr_code_scanner,
          title: 'KHQR',
          subtitle: 'Pay with KHQR',
          isSelected: true,
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodItem(
          icon: Icons.credit_card,
          title: 'Credit/Debit Card',
          subtitle: 'Visa, Mastercard',
          isSelected: false,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return Container(
      padding: EdgeInsets.all(XPadding.large),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? goBusPrimary : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: goBusPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: goBusPrimary, size: 24),
          ),
          SizedBox(width: XPadding.large),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle, color: goBusPrimary, size: 24)
          else
            Icon(Icons.circle_outlined, color: Colors.grey.shade400, size: 24),
        ],
      ),
    );
  }

  Widget _buildTopUpButton() {
    return SizedBox(
      width: double.infinity,
      child: XButton(
        label: 'Continue to Payment'.tr,
        optionbutton: 1,
        bgColor: goBusPrimary,
        onTap: () {
          final amount = selectedAmount ?? 
              (double.tryParse(_amountController.text) ?? 0);
          
          if (amount <= 0) {
            Get.snackbar(
              'Error'.tr,
              'Please enter a valid amount'.tr,
              backgroundColor: errorPrimary,
              colorText: Colors.white,
            );
            return;
          }

          // Navigate to payment screen
          Get.snackbar(
            'Success'.tr,
            'Processing top up of \$${amount.toStringAsFixed(2)}'.tr,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      ),
    );
  }
}
