import 'dart:developer';

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
    fetchRouteByID();
  }

  Future<void> fetchRouteByID() async {
    // Set loading
    updateState((state) => state.copyWith(isLoading: true));
    final result = await _repository.fetchRouteById(
      3,
      '2025-11-20',
      '2026-01-20',
    );

    switch (result) {
      case Success<RouteListResponseModel?>():
        {
          updateState(
            (state) => state.copyWith(
              model: result.data ?? RouteListResponseModel(),
              isLoading: false,
            ),
          );
          log("Success ${result.data}");
        }
      case Error<RouteListResponseModel?>():
        {
          updateState((state) => state.copyWith(isLoading: false));
        }
    }
  }
}
