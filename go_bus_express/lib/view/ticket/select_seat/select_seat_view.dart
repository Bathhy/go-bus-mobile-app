import 'package:flutter/material.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/xwidget/TextComponent.dart';
import 'package:shared_package/design_system/xwidget/x_app_bar.dart';

class SelectSeatView extends StatefulWidget {
  const SelectSeatView({super.key});

  @override
  State<SelectSeatView> createState() => _SelectSeatViewState();
}

class _SelectSeatViewState extends State<SelectSeatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: XAppBar(
          title: 'Phnom Penh → Siem Reap',
          subTitle: "2025-10-08",
          onBackPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: XPadding.large,
          children: [
            SizedBox(height: XPadding.extralarge),
            XTextLarge(
              label: 'Select Seat',
              colortext: black,
              fontWeight: FontWeight.w600,
            ),

            Row(
              spacing: XPadding.large,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: XPadding.large,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.red,
                  ),
                ),
                XTextMedium(label: 'Booked', colortext: Colors.grey),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: XPadding.large,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey,
                  ),
                ),
                XTextMedium(label: 'Available', colortext: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
