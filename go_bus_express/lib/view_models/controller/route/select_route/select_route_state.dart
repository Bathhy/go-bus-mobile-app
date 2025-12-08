import 'package:go_bus_express/models/route/detail_route_model.dart';

class SelectRouteState {
  final bool isLoading;
  final DetailRouteModel? model;

  SelectRouteState({
    this.isLoading = false,
    this.model = const DetailRouteModel(),
  });

  SelectRouteState copyWith({bool? isLoading, DetailRouteModel? model}) {
    return SelectRouteState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
    );
  }
}

