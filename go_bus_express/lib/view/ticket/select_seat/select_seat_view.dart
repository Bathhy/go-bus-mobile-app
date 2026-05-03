import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/services/websocket_service.dart';
import 'package:go_bus_express/data/network/network_constant.dart';
import 'package:go_bus_express/models/route/seat_layout_model.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view/ticket/select_seat/widgets/connection_status_indicator.dart';
import 'package:go_bus_express/view/ticket/select_seat/widgets/seat_grid_item.dart';
import 'package:go_bus_express/view_models/controller/route/select_seat/select_seat_controller.dart';
import 'package:intl/intl.dart';
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
  late final SelectSeatController controller;

  @override
  void initState() {
    super.initState();
    // Get the controller from GetIt (which also registers it with GetX)
    controller = getIt<SelectSeatController>();
    print('🔍 [SelectSeatView] Controller obtained from GetIt');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final state = controller.state;

          String formattedDate = 'N/A';
          if (state.departureDate != null && state.departureDate!.isNotEmpty) {
            try {
              final dt = DateTime.parse(state.departureDate!);
              formattedDate = DateFormat('EEE, MMM d, yyyy').format(dt);
            } catch (_) {
              formattedDate = state.departureDate!;
            }
          }

          return XAppBar(
            title: '${state.origin} → ${state.destination}',
            subTitle: formattedDate,
            onBackPressed: () => Get.back(),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ConnectionStatusIndicator(
                  status: state.connectionStatus,
                  onRetry: controller.retryConnection,
                ),
              ),
            ],
          );
        }),
      ),
      body: Obx(() {
        final state = controller.state;

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final layout = state.model?.layout?.layout?.seats;

        if (layout == null || layout.isEmpty) {
          return Center(
            child: XTextMedium(label: 'no_seat'.tr, colortext: Colors.grey),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: XPadding.extralarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: XPadding.extralarge),
                    XTextLarge(
                      label: 'Select Seat'.tr,
                      colortext: black,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: XPadding.large),
                    _buildLegend(),
                    SizedBox(height: XPadding.large),
                    AppSvgImage(
                      path: AppImages.icBusDriver,
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(height: XPadding.medium),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: layout.map((row) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: XPadding.medium),
                              child: _buildRow(row, controller),
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
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(XPadding.extralarge),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Obx(() {
            final state = controller.state;
            final hasSeats = state.selectedSeats.isNotEmpty;

            return XButton(
              height: 52,
              label: hasSeats
                  ? '${'Confirm'.tr} (${state.selectedSeats.length})'
                  : 'Confirm'.tr,
              optionbutton: 1,
              bgColor: hasSeats ? goBusPrimary : Colors.grey,
              onTap: hasSeats
                  ? () {
                      Get.toNamed(
                        AppRoutes.choosePayment,
                        arguments: {
                          'origin': state.origin,
                          'destination': state.destination,
                          'departureDate': state.departureDate,
                          'departureTime': state.departureTime,
                          'selectedSeats': state.selectedSeats,
                          'selectedSeatIds': state.selectedSeatIds,
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

  Widget _buildLegend() {
    return Wrap(
      spacing: XPadding.large,
      runSpacing: XPadding.small,
      children: const [
        _LegendItem(color: Color(0xFFEF9A9A), label: 'Booked'),
        _LegendItem(color: Colors.grey, label: 'Available'),
        _LegendItem(color: Color(0xFFF48FB1), label: 'My Selection'),
        _LegendItem(color: Color(0xFFFFB74D), label: "Others' Pending"),
      ],
    );
  }

  Widget _buildRow(List<SeatPosition> rowSeats, SelectSeatController controller) {
    return Row(
      children: rowSeats.asMap().entries.map((entry) {
        final index = entry.key;
        final seatPosition = entry.value;
        final seatNumber = seatPosition.seatNumber;

        if (seatNumber == null || seatNumber.isEmpty) {
          return SizedBox(width: XPadding.extralarge * 2, height: 70);
        }

        final needsSpacing =
            index > 0 && rowSeats[index - 1].seatNumber != null;

        return Row(
          children: [
            if (needsSpacing) SizedBox(width: XPadding.small),
            SeatGridItem(
              seatNumber: seatNumber,
              info: controller.state.realtimeSeats[seatNumber],
              currentUserId: controller.currentUserId,
              isLegacySelected: controller.isSeatSelected(seatNumber),
              isLegacyBooked: !controller.isSeatAvailable(seatNumber),
              onTap: () => controller.toggleSeat(seatNumber),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
