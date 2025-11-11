import 'package:flutter/material.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart'; 
import 'package:shared_package/design_system/xwidget/x_app_bar.dart';

class KHQRPaymentView extends StatelessWidget {
  const KHQRPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: XAppBar(
          title: 'Make Payment',
          onBackPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          spacing: XPadding.extralarge,
          children: [
            Container(
              width: double.infinity,
              height: 80,
              color: white,
              child: Image.asset(AppImages.imgBus),
            ),
            SizedBox(height: XPadding.medium),
            KhqrCardWidget(
              qr:
                  "00020101021229220018chin_kongming@aclb520459995802KH5914CHIN KONG MING6010Phnom Penh991700131762878671390541100000000.01530384062530111TRX012345670211855813620350305MShop0710Cashier-01630454B0",
              width: 300.0,
              receiverName: 'GO-Bus Express',
              amount: 10002.00,
              keepIntegerDecimal: false,
              currency:
                  KhqrCurrency
                      .usd, // Make sure currency matches the generated one
            ),
            // Instructions
            const Text(
              'Scan to pay with any banking',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            // SubTotal
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'SubTotal: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '\$10002',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
