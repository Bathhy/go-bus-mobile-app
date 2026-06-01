import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/utils/date_ext.dart';
import 'package:go_bus_express/models/route/detail_route_model.dart';
import 'package:go_bus_express/repository/route_repository.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/route/select_route/select_route_state.dart';
import 'package:shared_package/network/x_result.dart';

class SelectRouteController extends BaseController<SelectRouteState> {
  final RouteRepository _repository;

  SelectRouteController(this._repository) : super(SelectRouteState());

  @override
  void onInit() {
    super.onInit();
    _initArgsAndFetch();
  }

  void _initArgsAndFetch() {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      log('❌ No arguments passed to SelectRouteController');
      return;
    }

    final routeId = args['route_id'] as int?;
    final departureDate = args['departure_date'] as String?;
    final origin = args['origin'] as String?;
    final destination = args['destination'] as String?;

    if (routeId == null || departureDate == null) {
      log('❌ Missing required parameters');
      return;
    }

    /// 🔥 Update state immediately so UI can show data
    updateState(
      (state) => state.copyWith(
        routeId: routeId,
        departureDate: departureDate,
        returnDate: "",
        origin: origin ?? "",
        destination: destination ?? "",
        isLoading: true,
      ),
    );

    /// Then fetch data
    fetchRouteByID(
      routeId: routeId,
      departureDate: departureDate,
      returnDate: "",
    );
  }

  /// Builds the fromDateTime for the API:
  /// - today → current time (so already-departed schedules are excluded)
  /// - future date → midnight of that date (show all schedules for the day)
  String _buildFromDateTime(String departureDateStr) {
    final now = DateTime.now();
    final departureDay = DateTime.tryParse(departureDateStr);
    if (departureDay == null) return departureDateStr;

    final isToday = departureDay.year == now.year &&
        departureDay.month == now.month &&
        departureDay.day == now.day;

    return isToday
        ? now.toLocalDateTimeString()
        : DateTime(departureDay.year, departureDay.month, departureDay.day)
            .toLocalDateTimeString();
  }

  Future<void> fetchRouteByID({
    required int routeId,
    required String departureDate,
    required String returnDate,
  }) async {
    final fromDateTime = _buildFromDateTime(departureDate);
    print('🔍 DEBUG: routeId = $routeId');
    print('🔍 DEBUG: fromDateTime = $fromDateTime');

    final result = await _repository.fetchBusBySchedule(routeId, fromDateTime);

    log('🔍 DEBUG: API call completed');

    switch (result) {
      case Success<RouteListResponseModel?>():
        {
          updateState(
            (state) => state.copyWith(
              model: result.data ?? RouteListResponseModel(),
              isLoading: false,
            ),
          );
          log(
            "Route>>>>>>"
            '${result.data?.route?.origin}',
          );
        }

      case Error<RouteListResponseModel?>():
        updateState((state) => state.copyWith(isLoading: false));
        log("❌ Error loading schedules: ${result.error.displayMessage}");
        _showError(result.error.displayMessage);
    }
  }

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).clearSnackBars();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(message, style: const TextStyle(color: Colors.white)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }
}
