import 'package:go_bus_express/models/route/detail_route_model.dart';
import 'package:shared_package/network/x_result.dart';

import '../data/app_api/go_bus_api.dart';

abstract class RouteRepository {
  Future<XResult<DetailRouteModel?>> fetchRouteById(int id);
}

class RouteRepositoryImpl implements RouteRepository {
  final GoBusApi api;

  RouteRepositoryImpl(this.api);

  @override
  Future<XResult<DetailRouteModel?>> fetchRouteById(int id) async {
    return xResultHandler(() async {
      final result = await api.fetchRouteDetail(id);
      return result.data;
    });
  }
}
