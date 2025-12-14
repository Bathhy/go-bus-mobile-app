import 'package:go_bus_express/models/route/detail_route_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';

class SelectRouteState extends BaseUiState {
  final RouteListResponseModel? model;
  final int routeId;
  final String departureDate;
  final String returnDate;

  SelectRouteState({
    super.isLoading = false,
    this.model = const RouteListResponseModel(),
    this.routeId = 0,
    this.departureDate = "",
    this.returnDate = "",
  });

  SelectRouteState copyWith({
    bool? isLoading,
    RouteListResponseModel? model,
    int? routeId,
    String? departureDate,
    String? returnDate,
  }) {
    return SelectRouteState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      routeId: routeId ?? this.routeId,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
    );
  }
}
