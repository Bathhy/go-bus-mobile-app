import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/core/utils/string_ext.dart';
import 'package:go_bus_express/models/route/detail_route_model.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/utils/string_ext.dart';
import 'package:go_bus_express/view_models/controller/route/select_route/select_route_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';
import 'package:shared_package/design_system/x_widget/x_location_title.dart';

class SelectRouteView extends StatelessWidget {
  const SelectRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    final SelectRouteController controller = getIt<SelectRouteController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => XAppBar(
            title:
                '${controller.state.model?.route?.origin.orDefault("Origin")} → ${controller.state.model?.route?.destination.orDefault("Destination")}',
            subTitle: controller.state.departureDate.orDefault("N/A"),
            onBackPressed: () => Get.back(),
          ),
        ),
      ),
      body: Obx(
        () => controller.state.isLoading
            ? Center(child: CircularProgressIndicator(color: goBusPrimary))
            : Column(
                children: [
                  _buildTripInfo(controller),
                  Expanded(
                    child: controller.state.model?.schedules?.isEmpty == true
                        ? Center(
                            child: Text(
                              'No buses available'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: XPadding.extralarge,
                            ),
                            itemCount:
                                controller.state.model?.schedules?.length ?? 0,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: XPadding.small),
                            itemBuilder: (context, index) {
                              final model = controller.state.model?.schedules
                                  ?.elementAt(index);
                              return _buildBusCard(
                                departDate: controller.state.departureDate,
                                routeModel: controller.state.model?.route,
                                budId: model?.busId,
                                departureTime: model?.departureTime ?? '23:30',
                                arrivalTime: '23:22',
                                duration: minutesToHours(
                                  model?.bus?.route?.durationMinutes ?? 0,
                                ).toString(),
                                price: '\$${model?.price}',
                                availableSeats:
                                    '${model?.bus?.bookedSeats ?? 0}/${model?.bus?.totalSeats ?? 0} Seats',
                                departureLocation:
                                    'Boarding: ${model?.bus?.route?.origin ?? 'N/A'}',
                                arrivalLocation:
                                    'Boarding: ${model?.bus?.route?.destination ?? 'N/A'}',
                                busType: model?.bus?.busType ?? 'Bus',
                              );
                            },
                          ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
      ),
    );
  }

  Widget _buildTripInfo(SelectRouteController controller) {
    final busCount = controller.state.model?.schedules?.length ?? 0;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                'Select Time'.tr,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            '$busCount Available Trips',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBusCard({
    required String departureTime,
    required String arrivalTime,
    required String duration,
    required String price,
    required String availableSeats,
    required String departureLocation,
    required String arrivalLocation,
    String busType = 'Bus',
    int? budId,
    RouteModel? routeModel,
    required String departDate,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/image 18.png', width: 24, height: 24),
              const SizedBox(width: 12),
              Text(
                busType,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              Text(
                availableSeats,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Departure Time',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    departureTime,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              _buildTimeLineArrow(duration),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Arrival',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    arrivalTime,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              XLocationTitle(localtion: departureLocation),
              XLocationTitle(localtion: arrivalLocation),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.grey.shade300,
            child: Row(
              children: List.generate(
                20,
                (index) => Expanded(
                  child: Container(
                    color: index % 2 == 0
                        ? Colors.transparent
                        : Colors.grey.shade300,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: success,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.selectSeat,
                    arguments: {
                      'scheduleId': 6,
                      'busId': budId,
                      'origin': routeModel?.origin ?? 'Origin',
                      'destination': routeModel?.destination ?? 'Destination',
                      'departureDate': departDate.orDefault("N/A"),
                      'departureTime': departureTime,
                      'unitPrice':
                          double.tryParse(price.replaceAll('\$', '')) ?? 0.0,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: success,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: XPadding.extralarge,
                    vertical: XPadding.medium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Book Now'.tr,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLineArrow(String duration) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(child: Container(height: 2, color: Colors.black)),
              Container(
                width: 0,
                height: 0,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.transparent, width: 5),
                    right: BorderSide(color: Colors.black, width: 8),
                    bottom: BorderSide(color: Colors.transparent, width: 5),
                  ),
                ),
              ),
            ],
          ),
          Text(
            duration,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
