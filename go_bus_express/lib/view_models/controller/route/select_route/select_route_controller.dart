import 'dart:developer';

import 'package:get/get.dart';
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

  Future<void> fetchRouteByID({
    required int routeId,
    required String departureDate,
    required String returnDate,
  }) async {
    print('🔍 DEBUG: routeId = $routeId');
    print('🔍 DEBUG: departureDate = $departureDate');

    final result = await _repository.fetchBusBySchedule(routeId, departureDate);

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
    }
  }
}
