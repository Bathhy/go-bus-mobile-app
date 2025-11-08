import 'package:flutter/material.dart';
import 'package:shared_package/design_system/xwidget/AppImage.dart';
import 'package:shared_package/design_system/xwidget/x_app_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../resources/app_images.dart';
import 'package:khqr_sdk/khqr_sdk.dart';

class KHQRPaymentView extends StatelessWidget {
  const KHQRPaymentView({super.key});

  @override
  Widget build(BuildContext context) {

    final info = MerchantInfo(
      bakongAccountId: 'kimhak@dev',
      acquiringBank: 'Dev Bank',
      merchantId: '123456',
      merchantName: 'Kimhak',
      currency: KhqrCurrency.usd,
      amount: 0,
    );
    final res = KhqrSdk.generateMerchant(info);
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
          children: [
            KhqrCardWidget(
              width: 300.0,
              receiverName: 'Kimhak',
              amount: 0.00,
              keepIntegerDecimal: false,
              currency: KhqrCurrency.khr,
              qr: khqrContent,
            ),
            // Instructions
            const Text(
              'Scan to pay with any banking',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 20),

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

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1;

    const dashWidth = 5;
    const dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
