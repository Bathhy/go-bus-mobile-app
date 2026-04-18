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
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Top Up Wallet'.tr,
          style: TextStyle(
            fontSize: 20,
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
                    _buildTopUpCard(),
                    const SizedBox(height: 28),
                    Text(
                      'Enter Amount'.tr,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildAmountInput(),
                    const SizedBox(height: 18),
                    _buildQuickAmountRow(),
                    const SizedBox(height: 24),
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

  Widget _buildTopUpCard() {
    return Container(
      padding: EdgeInsets.all(XPadding.extralarge),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL BALANCE'.tr,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Color(0xFF4D5562),
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$75.00',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: goBusPrimary,
                        ),
                      ),
                      const TextSpan(
                        text: ' / 300,000 KHR',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF353B44),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Color(0xFFA64D00),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E8EE),
        borderRadius: BorderRadius.circular(14),
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
            final matchedAmount = quickAmounts
                .where((a) => a == parsed)
                .firstOrNull;
            selectedAmount = matchedAmount;
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: XPadding.large,
            vertical: XPadding.large + 2,
          ),
          prefixText: '\$  ',
          prefixStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: goBusPrimary,
          ),
        ),
        style: TextStyle(
          fontSize: 18,
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
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedAmount = amount;
                  _amountController.text = amount.toStringAsFixed(0);
                });
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? goBusPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: goBusPrimary.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '\$${amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1E2228),
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
      padding: EdgeInsets.all(XPadding.large),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF13B5A8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.info, color: Colors.white, size: 20),
          ),
          SizedBox(width: XPadding.large - 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'gobus_wallet_topup_title'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2228),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'gobus_wallet_topup_description'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A5160),
                    height: 1.4,
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
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: goBusPrimary,
            foregroundColor: Colors.white,
            shadowColor: goBusPrimary.withOpacity(0.35),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
