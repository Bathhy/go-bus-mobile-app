import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/ButtonComponent.dart';
import 'package:shared_package/design_system/x_widget/TextComponent.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';

class ChoosePaymentView extends StatefulWidget {
  const ChoosePaymentView({super.key});

  @override
  State<ChoosePaymentView> createState() => _ChoosePaymentViewState();
}

class _ChoosePaymentViewState extends State<ChoosePaymentView> {
  String? selectedPayment;
  bool agreedToTerms = false;
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
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
      body: SingleChildScrollView(
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

              _buildSummaryRow('Direction'.tr, 'Phnom Penh - Siem Reap'),
              SizedBox(height: XPadding.medium),
              _buildSummaryRow('Departure Date'.tr, '2025-05-12 0 4:30 PM'),
              SizedBox(height: XPadding.medium),
              _buildSummaryRow('Seat No'.tr, '10'),
              SizedBox(height: XPadding.medium),
              _buildSummaryRow('Unit Price'.tr, '\$13.00'),
              SizedBox(height: XPadding.medium),
              _buildSummaryRow('Discount'.tr, '\$0.00'),
              SizedBox(height: XPadding.medium),
              _buildSummaryRow('Net Price', '\$13.00', isBold: true),
              SizedBox(height: XPadding.extralarge),

              // Note field
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: XPadding.large,
                  vertical: XPadding.medium,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.grey.shade600, size: 20),
                    SizedBox(width: XPadding.medium),
                    Expanded(
                      child: TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          hintText: 'Note'.tr,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                  ],
                ),
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
                Colors.red,
              ),
              SizedBox(height: XPadding.extralarge),

              // Terms checkbox
              GestureDetector(
                onTap: () {
                  setState(() {
                    agreedToTerms = !agreedToTerms;
                  });
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                      activeColor: Colors.greenAccent,
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
      ),
      bottomNavigationBar: Container(
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
            label: 'Pay \$13:00',
            optionbutton: 1,
            bgColor: goBusPrimary,
            onTap: () => Get.toNamed(AppRoutes.makePayment),
          ),
        ),
      ),
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
    Color logoColor,
  ) {
    return Container(
      padding: EdgeInsets.all(XPadding.large),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
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
            child: Image.asset(AppImages.imgBakong, width: 40, height: 40),
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
        ],
      ),
    );
  }
}
