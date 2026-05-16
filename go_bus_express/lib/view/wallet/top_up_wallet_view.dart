import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';

class TopUpWalletView extends StatefulWidget {
  const TopUpWalletView({super.key});

  @override
  State<TopUpWalletView> createState() => _TopUpWalletViewState();
}

class _TopUpWalletViewState extends State<TopUpWalletView> {
  final TextEditingController _amountController = TextEditingController();
  double? selectedAmount = 20;
  final List<double> quickAmounts = [10, 20, 50, 100];

  @override
  void initState() {
    super.initState();
    _amountController.text = '20.00';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: goBusPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Top Up Wallet'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: goBusPrimary,
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
                    _buildBalanceCard(),
                    const SizedBox(height: 24),
                    Text(
                      'Enter Amount'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E2228),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildAmountInput(),
                    const SizedBox(height: 14),
                    _buildQuickAmountRow(),
                    const SizedBox(height: 20),
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
              child: _buildTopUpButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: goBusPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: goBusPrimary,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL BALANCE'.tr,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: Color(0xFF8D94A0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$75.00',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: goBusPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E8EE)),
      ),
      child: TextField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        onChanged: (value) {
          final parsed = double.tryParse(value);
          setState(() {
            if (parsed == null) {
              selectedAmount = null;
              return;
            }
            selectedAmount = quickAmounts.where((a) => a == parsed).firstOrNull;
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixText: '\$  ',
          prefixStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: goBusPrimary,
          ),
          hintText: '0.00',
          hintStyle: const TextStyle(color: Color(0xFFBCC0C8)),
        ),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: goBusPrimary,
        ),
      ),
    );
  }

  Widget _buildQuickAmountRow() {
    return Row(
      children: quickAmounts.map((amount) {
        final isSelected = selectedAmount == amount;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedAmount = amount;
                  _amountController.text = amount.toStringAsFixed(0);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? goBusPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? goBusPrimary : const Color(0xFFE5E8EE),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: goBusPrimary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '\$${amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF4A5160),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
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
            child: Icon(Icons.info_outline, color: goBusPrimary, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'gobus_wallet_topup_title'.tr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2228),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'gobus_wallet_topup_description'.tr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpButton() {
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
          final amount = double.tryParse(_amountController.text) ?? 0;

          if (amount <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please enter a valid amount'.tr),
                backgroundColor: errorPrimary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }

          Get.toNamed(
            AppRoutes.paymentWalletSelection,
            arguments: {
              'usdAmount': amount,
              'khrAmount': (amount * 4000).round(),
            },
          );
        },
        child: Text(
          'Continue'.tr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
