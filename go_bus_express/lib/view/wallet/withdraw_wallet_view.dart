import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';

class WithdrawWalletView extends StatefulWidget {
  const WithdrawWalletView({super.key});

  @override
  State<WithdrawWalletView> createState() => _WithdrawWalletViewState();
}

class _WithdrawWalletViewState extends State<WithdrawWalletView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  final List<String> _banks = ['ABA Bank', 'ACLEDA Bank', 'Wing Bank'];
  String? _selectedBank;
  final double _availableBalanceUsd = 4850.0;
  final double _usdToKhrRate = 4000;

  @override
  void dispose() {
    _amountController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final equivalentKhr = (amount * _usdToKhrRate).round();

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
          'withdraw_funds'.tr,
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
                    Text(
                      'transfer_details'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B4252),
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildBalanceCard(),
                    const SizedBox(height: 24),
                    _buildFieldLabel('select_bank'.tr),
                    const SizedBox(height: 8),
                    _buildBankSelector(),
                    const SizedBox(height: 16),
                    _buildFieldLabel('Amount'.tr),
                    const SizedBox(height: 8),
                    _buildAmountField(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'equivalent_to'.tr} ${_formatThousands(equivalentKhr)} KHR',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6C7481),
                          ),
                        ),
                        GestureDetector(
                          onTap: _onMaxAmount,
                          child: Text(
                            'max_amount'.tr,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFCC531D),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFieldLabel('account_name'.tr),
                    const SizedBox(height: 8),
                    _buildTextInput(
                      controller: _accountNameController,
                      hintText: 'enter_full_name'.tr,
                    ),
                    const SizedBox(height: 16),
                    _buildFieldLabel('account_number'.tr),
                    const SizedBox(height: 8),
                    _buildTextInput(
                      controller: _accountNumberController,
                      hintText: '000 000 000',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                      ],
                      suffixIcon: Icon(
                        Icons.account_balance,
                        color: goBusPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFieldLabel('remark_optional'.tr),
                    const SizedBox(height: 8),
                    _buildTextInput(
                      controller: _remarkController,
                      hintText: 'withdraw_remark_hint'.tr,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    _buildFieldLabel('upload_bank_khqr'.tr),
                    const SizedBox(height: 8),
                    _buildUploadCard(),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                XPadding.extralarge,
                12,
                XPadding.extralarge,
                XPadding.extralarge,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: goBusPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _onSubmit,
                  child: Text(
                    'Submit'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'available_balance'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF525A67),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$${_availableBalanceUsd.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                          color: goBusPrimary,
                        ),
                      ),
                      const TextSpan(
                        text: ' USD',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3F4653),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE3E7F0),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E8EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBank,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          hint: Text(
            'choose_your_bank'.tr,
            style: const TextStyle(fontSize: 16, color: Color(0xFF3C4351)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          items: _banks
              .map(
                (bank) => DropdownMenuItem<String>(
                  value: bank,
                  child: Text(
                    bank,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1F2530),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedBank = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E8EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          prefixText: 'USD    ',
          prefixStyle: TextStyle(
            fontSize: 16,
            color: Color(0xFF3E6BE0),
            fontWeight: FontWeight.w700,
          ),
          hintText: '0.00',
          hintStyle: TextStyle(
            color: Color(0xFF6D7482),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: const TextStyle(
          color: Color(0xFF232833),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E8EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF6D7482), fontSize: 16),
          suffixIcon: suffixIcon,
        ),
        style: const TextStyle(
          color: Color(0xFF232833),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('upload_qr_coming_soon'.tr),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD9DEE8), width: 1.2),
        ),
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.cloud_upload_rounded,
                color: goBusPrimary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'tap_to_upload_qr'.tr,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E2430),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'upload_qr_format'.tr,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6F7784),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF2C3442),
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void _onMaxAmount() {
    setState(() {
      _amountController.text = _availableBalanceUsd.toStringAsFixed(2);
    });
  }

  void _onSubmit() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedBank == null ||
        amount <= 0 ||
        _accountNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('fill_required_fields'.tr),
          backgroundColor: errorPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('withdraw_request_submitted'.tr),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatThousands(int number) {
    final value = number.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      final reverseIndex = value.length - i;
      buffer.write(value[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }
}
