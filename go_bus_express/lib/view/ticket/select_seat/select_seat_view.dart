import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/AppImage.dart';
import 'package:shared_package/design_system/x_widget/ButtonComponent.dart';
import 'package:shared_package/design_system/x_widget/TextComponent.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';

class SelectSeatView extends StatefulWidget {
  const SelectSeatView({super.key});

  @override
  State<SelectSeatView> createState() => _SelectSeatViewState();
}

class _SelectSeatViewState extends State<SelectSeatView> {
  final List<int> bookedSeats = [1, 2, 3, 5, 6, 7, 12];
  int? selectedSeat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: XAppBar(
          title: 'Phnom Penh → Siem Reap',
          subTitle: "2025-10-08",
          onBackPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: XPadding.large,
                children: [
                  SizedBox(height: XPadding.extralarge),
                  XTextLarge(
                    label: 'Select Seat'.tr,
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
                          color: Colors.red.shade300,
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
                  // Driver icon
                  AppSvgImage(
                    path: AppImages.icBusDriver,
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(height: XPadding.medium),

                  // Seat layout
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildSeatRow(1, 5, 9, 13),
                          SizedBox(height: XPadding.medium),
                          _buildSeatRow(2, 6, 10, 14),
                          SizedBox(height: XPadding.medium),
                          _buildSeatRow(3, 7, 11, 15),
                          SizedBox(height: XPadding.medium),
                          _buildSeatRow(4, 8, 12, 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // move the confirm button to bottomNavigationBar so it always sticks to the bottom
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
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
          child: XButton(
            height: 52,
            label: 'Confirm'.tr,
            optionbutton: 1,
            bgColor: goBusPrimary,
            onTap: () => Get.toNamed(AppRoutes.choosePayment),
          ),
        ),
      ),
    );
  }

  Widget _buildSeat(
    int seatNumber, {
    bool isBooked = false,
    bool isSelected = false,
  }) {
    Color seatColor;
    if (isBooked) {
      seatColor = Colors.red.shade300;
    } else if (isSelected) {
      seatColor = Colors.pink.shade200;
    } else {
      seatColor = Colors.grey.shade500;
    }

    return GestureDetector(
      onTap:
          isBooked
              ? null
              : () {
                setState(() {
                  selectedSeat = seatNumber;
                });
              },
      child: SizedBox(
        width: 70,
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AppSvgImage(
              path: AppImages.icSeat,
              width: 70,
              height: 70,
              color: seatColor,
            ),
            Text(
              seatNumber.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatRow(int seat1, int seat2, int seat3, int seat4) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSeat(
          seat1,
          isBooked: bookedSeats.contains(seat1),
          isSelected: selectedSeat == seat1,
        ),
        SizedBox(width: XPadding.small),
        _buildSeat(
          seat2,
          isBooked: bookedSeats.contains(seat2),
          isSelected: selectedSeat == seat2,
        ),
        SizedBox(width: XPadding.extralarge * 2),
        _buildSeat(
          seat3,
          isBooked: bookedSeats.contains(seat3),
          isSelected: selectedSeat == seat3,
        ),
        SizedBox(width: XPadding.small),
        _buildSeat(
          seat4,
          isBooked: bookedSeats.contains(seat4),
          isSelected: selectedSeat == seat4,
        ),
      ],
    );
  }
}
