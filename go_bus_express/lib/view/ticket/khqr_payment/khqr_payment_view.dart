import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/xwidget/x_app_bar.dart';

class KHQRPaymentView extends StatefulWidget {
  const KHQRPaymentView({super.key});

  @override
  State<KHQRPaymentView> createState() => _KHQRPaymentViewState();
}

class _KHQRPaymentViewState extends State<KHQRPaymentView> {
  late Timer _timer;
  int _remainingSeconds = 180; // 3 minutes = 180 seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        // Show timeout dialog or navigate back
        _showTimeoutDialog();
      }
    });
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Payment Timeout'),
            content: Text('Your payment session has expired.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back
                },
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: shimerBgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Column(
          children: [
            XAppBar(
              title: 'Make Payment',
              onBackPressed: () {
                _timer.cancel();
                Navigator.of(context).pop();
              },
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: XPadding.medium, horizontal: XPadding.small),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(XPadding.medium),
                    ),
                    color:
                        _remainingSeconds <= 30
                            ? Colors.red.shade100
                            : Colors.orange.shade100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color:
                            _remainingSeconds <= 30
                                ? Colors.red
                                : Colors.orange,
                        size: 20,
                      ),
                      SizedBox(width: XPadding.small),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              _remainingSeconds <= 30
                                  ? Colors.red.shade900
                                  : Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: XPadding.extralarge),
              ],
            ),
          ],
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
