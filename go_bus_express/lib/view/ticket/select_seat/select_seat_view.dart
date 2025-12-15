import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/utils/string_ext.dart';
import 'package:go_bus_express/view_models/controller/route/select_seat/select_seat_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/AppImage.dart';
import 'package:shared_package/design_system/x_widget/ButtonComponent.dart';
import 'package:shared_package/design_system/x_widget/TextComponent.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';

import '../../../core/di/app_di.dart';

class SelectSeatView extends StatefulWidget {
  const SelectSeatView({super.key});

  @override
  State<SelectSeatView> createState() => _SelectSeatViewState();
}

class _SelectSeatViewState extends State<SelectSeatView> {
  @override
  Widget build(BuildContext context) {
    final SelectSeatController controller = getIt<SelectSeatController>();

    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final state = controller.state;
          return XAppBar(
            title: '${state.origin} → ${state.destination}',
            subTitle: state.departureDate.orDefault("N/A"),
            onBackPressed: () => Get.back(),
          );
        }),
      ),
      body: Obx(() {
        final state = controller.state;

        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final layout = state.model?.layout?.layout?.layout;

        if (layout == null || layout.isEmpty) {
          return Center(
            child: XTextMedium(
              label: 'No seat layout available',
              colortext: Colors.grey,
            ),
          );
        }

        return Column(
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
                        XTextMedium(label: 'Booked'.tr, colortext: Colors.grey),
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
                        XTextMedium(
                          label: 'Available'.tr,
                          colortext: Colors.grey,
                        ),
                      ],
                    ),
                    // Driver icon
                    AppSvgImage(
                      path: AppImages.icBusDriver,
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(height: XPadding.medium),

                    // Seat layout - dynamically built from API
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: layout.map((row) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: XPadding.medium),
                              child: _buildDynamicSeatRow(row, controller),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
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
          child: Obx(() {
            final state = controller.state;
            final hasSelectedSeats = state.selectedSeats.isNotEmpty;

            return XButton(
              height: 52,
              label: hasSelectedSeats
                  ? 'Confirm (${state.selectedSeats.length} ${state.selectedSeats.length == 1 ? 'seat' : 'seats'})'
                        .tr
                  : 'Confirm'.tr,
              optionbutton: hasSelectedSeats ? 1 : 0,
              bgColor: hasSelectedSeats ? goBusPrimary : Colors.grey,
              onTap: hasSelectedSeats
                  ? () {
                      Get.toNamed(
                        AppRoutes.choosePayment,
                        arguments: {
                          'origin': state.origin,
                          'destination': state.destination,
                          'departureDate': state.departureDate,
                          'departureTime': state.departureTime,
                          'selectedSeats': state.selectedSeats, // For display
                          'selectedSeatIds': state.selectedSeatIds, // For backend
                          'unitPrice': state.unitPrice,
                          'discount': 0.0,
                          'scheduleId': state.scheduleId,
                        },
                      );
                    }
                  : null,
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSeat(
    String seatNumber,
    SelectSeatController controller, {
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
      onTap: isBooked
          ? null
          : () {
              controller.toggleSeat(seatNumber);
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
              seatNumber,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicSeatRow(
    List<String?> rowSeats,
    SelectSeatController controller,
  ) {
    return Row(
      children: rowSeats.asMap().entries.map((entry) {
        final index = entry.key;
        final seatNumber = entry.value;

        if (seatNumber == null) {
          // Aisle space - wider gap between seat groups
          return SizedBox(width: XPadding.extralarge * 2, height: 70);
        }

        final isBooked = !controller.isSeatAvailable(seatNumber);
        final isSelected = controller.isSeatSelected(seatNumber);

        // Add small spacing between seats in the same group
        final needsSpacing = index > 0 && rowSeats[index - 1] != null;

        return Row(
          children: [
            if (needsSpacing) SizedBox(width: XPadding.small),
            _buildSeat(
              seatNumber,
              controller,
              isBooked: isBooked,
              isSelected: isSelected,
            ),
          ],
        );
      }).toList(),
    );
  }
}
