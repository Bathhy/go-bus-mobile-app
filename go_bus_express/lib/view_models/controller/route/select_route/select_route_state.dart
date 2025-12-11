import 'package:go_bus_express/models/route/detail_route_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';

class SelectRouteState extends BaseUiState {
  final RouteListResponseModel? model;

  SelectRouteState({
    super.isLoading = false,
    this.model = const RouteListResponseModel(),
  });

  SelectRouteState copyWith({bool? isLoading, RouteListResponseModel? model}) {
    return SelectRouteState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
    );
  }
}
