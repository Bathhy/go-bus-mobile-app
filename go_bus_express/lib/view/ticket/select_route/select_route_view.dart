import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/core/utils/date_ext.dart';
import 'package:go_bus_express/core/utils/navigation_helper.dart';
import 'package:go_bus_express/core/utils/string_ext.dart';
import 'package:go_bus_express/models/route/detail_route_model.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/route/select_route/select_route_controller.dart';
import 'package:go_bus_express/view_models/controller/route/select_route/select_route_state.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';
import 'package:shared_package/design_system/x_widget/x_location_title.dart';

class SelectRouteView extends StatelessWidget {
  const SelectRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    final SelectRouteController controller = getIt<SelectRouteController>();
    final uiState = controller.state;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(
          () {
            // Use state's origin/destination first, fallback to API response
            final origin = controller.state.origin.isNotEmpty 
                ? controller.state.origin 
                : controller.state.model?.route?.origin ?? "Origin";
            final destination = controller.state.destination.isNotEmpty 
                ? controller.state.destination 
                : controller.state.model?.route?.destination ?? "Destination";
            
            // Format date using extension method
            final formattedDate = controller.state.departureDate.isNotEmpty
                ? controller.state.departureDate.toReadableDate() ?? "N/A"
                : "N/A";
            
            return XAppBar(
              title: '$origin → $destination',
              subTitle: formattedDate,
              onBackPressed: () => NavigationHelper.safeBack(),
            );
          },
        ),
      ),
      body: Obx(
        () => controller.state.isLoading
            ? _buildSkeletonLoader()
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
                        : RefreshIndicator(
                            color: goBusPrimary,
                            onRefresh: () => controller.fetchRouteByID(
                              routeId: uiState.routeId,
                              departureDate: uiState.departureDate,
                              returnDate: "",
                            ),
                            backgroundColor: white,
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(
                                horizontal: XPadding.extralarge,
                              ),
                              itemCount:
                                  controller.state.model?.schedules?.length ??
                                  0,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: XPadding.small),
                              itemBuilder: (context, index) {
                                final model = controller.state.model?.schedules
                                    ?.elementAt(index);
                                
                                // Format arrival time using extension method
                                final formattedArrivalTime = 
                                    model?.arrivalTime?.toTimeString() ?? 'N/A';

                                return _buildBusCard(
                                  state: uiState,
                                  scheduleId: model?.id,
                                  departDate: controller.state.departureDate,
                                  routeModel: controller.state.model?.route,
                                  budId: model?.busId,
                                  busNumber: model?.busNumber,
                                  departureTime:
                                      model?.departureTime
                                          ?.formattedTime()
                                          .orDefault("N/A") ??
                                      "",
                                  arrivalTime: formattedArrivalTime,
                                  duration: minutesToHours(
                                    controller
                                            .state
                                            .model
                                            ?.route
                                            ?.durationMinutes ??
                                        0,
                                  ).toString(),
                                  price:
                                      '\$${model?.price?.toStringAsFixed(2) ?? '0.00'}',
                                  departureLocation:
                                      '${'boarding'.tr}: ${controller.state.model?.route?.origin ?? 'N/A'}',
                                  arrivalLocation:
                                      '${'drop_off'.tr}: ${controller.state.model?.route?.destination ?? 'N/A'}',
                                );
                              },
                            ),
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
            'available_trips'.trParams({'count': busCount.toString()}),
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
    required String departureLocation,
    required String arrivalLocation,
    String? busNumber,
    int? budId,
    int? scheduleId,
    RouteModel? routeModel,
    required String departDate,
    required SelectRouteState state,
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
                busNumber != null ? 'Bus $busNumber' : 'bus'.tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
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
                    'departure_time'.tr,
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
                    'arrival'.tr,
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
                      'scheduleId': scheduleId ?? 0,
                      'busId': budId ?? 0,
                      'origin': state.origin,
                      'destination': state.destination,
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

  Widget _buildSkeletonLoader() {
    return Column(
      children: [
        _buildSkeletonTripInfo(),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
            itemCount: 3,
            separatorBuilder: (context, index) =>
                SizedBox(height: XPadding.small),
            itemBuilder: (context, index) => _buildSkeletonBusCard(),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  // MARK - Skeleton Trip Info
  Widget _buildSkeletonTripInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildShimmerBox(width: 16, height: 16, radius: 8),
              SizedBox(width: 4),
              _buildShimmerBox(width: 80, height: 14, radius: 4),
            ],
          ),
          _buildShimmerBox(width: 100, height: 14, radius: 4),
        ],
      ),
    );
  }

  // MARK - Skeleton Route Card
  Widget _buildSkeletonBusCard() {
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
              _buildShimmerBox(width: 24, height: 24, radius: 4),
              const SizedBox(width: 12),
              _buildShimmerBox(width: 60, height: 15, radius: 4),
              const Spacer(),
              _buildShimmerBox(width: 80, height: 12, radius: 4),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerBox(width: 80, height: 12, radius: 4),
                  const SizedBox(height: 4),
                  _buildShimmerBox(width: 50, height: 18, radius: 4),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildShimmerBox(
                      width: double.infinity,
                      height: 2,
                      radius: 1,
                    ),
                    const SizedBox(height: 4),
                    _buildShimmerBox(width: 40, height: 12, radius: 4),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildShimmerBox(width: 80, height: 12, radius: 4),
                  const SizedBox(height: 4),
                  _buildShimmerBox(width: 50, height: 18, radius: 4),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(width: 120, height: 12, radius: 4),
              _buildShimmerBox(width: 120, height: 12, radius: 4),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(width: 60, height: 15, radius: 4),
              _buildShimmerBox(width: 100, height: 40, radius: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
