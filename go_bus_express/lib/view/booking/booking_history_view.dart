import 'package:flutter/material.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/xwidget/TextComponent.dart';
import 'package:shared_package/design_system/xwidget/x_app_bar.dart';

class BookingHistoryView extends StatelessWidget {
  const BookingHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: XAppBar(
          title: 'Booking History',
          onBackPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(XPadding.extralarge),
        children: [
          _buildBookingCard(
            bookingId: 'GB123456789',
            date: '13 Oct, 2025',
            from: 'Phnom Penh',
            to: 'Kompong Cham',
            distance: '124.0 km',
            departureTime: '07:00 AM',
            arrivalTime: '09:30 AM',
            seats: '2 Seats',
            price: '\$10',
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard({
    required String bookingId,
    required String date,
    required String from,
    required String to,
    required String distance,
    required String departureTime,
    required String arrivalTime,
    required String seats,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goBusPrimary, width: 2),
      ),
      child: Column(
        children: [
          // Header section
          Container(
            padding: EdgeInsets.all(XPadding.large),
            decoration: BoxDecoration(
              color: goBusPrimary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    XTextMedium(
                      label: bookingId,
                      colortext: white,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: white, size: 14),
                        SizedBox(width: 4),
                        XTextSmall(
                          label: date,
                          colortext: white,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.airline_seat_recline_normal, color: white, size: 20),
                    SizedBox(width: 4),
                    XTextMedium(
                      label: seats,
                      colortext: white,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(width: XPadding.large),
                    XTextMedium(
                      label: price,
                      colortext: white,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Route section
          Padding(
            padding: EdgeInsets.all(XPadding.large),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    XTextMedium(
                      label: from,
                      colortext: black,
                      fontWeight: FontWeight.w600,
                    ),
                    Column(
                      children: [
                        Icon(Icons.directions_bus, color: Colors.grey, size: 24),
                        Container(
                          width: 80,
                          height: 2,
                          margin: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: CustomPaint(
                            painter: DashedLinePainter(),
                          ),
                        ),
                        XTextSmall(
                          label: distance,
                          colortext: Colors.grey,
                        ),
                      ],
                    ),
                    XTextMedium(
                      label: to,
                      colortext: black,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                SizedBox(height: XPadding.medium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    XTextMedium(
                      label: departureTime,
                      colortext: Colors.grey.shade700,
                    ),
                    XTextMedium(
                      label: arrivalTime,
                      colortext: Colors.grey.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
