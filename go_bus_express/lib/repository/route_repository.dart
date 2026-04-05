import 'package:go_bus_express/models/route/detail_route_model.dart';
import 'package:go_bus_express/models/route/seat_layout_model.dart';
import 'package:shared_package/network/x_result.dart';

import '../data/app_api/go_bus_api.dart';
import '../models/home/all_route_model.dart';

abstract class RouteRepository {
  Future<XResult<DetailRouteModel?>> fetchRouteById(int id);
  Future<XResult<List<AllRouteModel>>> fetchRoutes();
  Future<XResult<RouteListResponseModel?>> fetchBusBySchedule(
    int id,
    String? departureDate,
  );

  Future<XResult<SeatLayoutModel?>> fetchBusSeat(int scheduleId);
}

class RouteRepositoryImpl implements RouteRepository {
  final GoBusApi api;

  RouteRepositoryImpl(this.api);

  @override
  Future<XResult<SeatLayoutModel?>> fetchBusSeat(
    int scheduleId,
  ) async {
    return xResultHandler(() async {
      final result = await api.fetchBusSeat(scheduleId);
      return result.data;
    });
  }

  @override
  Future<XResult<List<AllRouteModel>>> fetchRoutes() async {
    return xResultHandler(() async {
      final result = await api.fetchRoutes();
      return result.data ?? [];
    });
  }

  @override
  Future<XResult<RouteListResponseModel?>> fetchBusBySchedule(
    int id,
    String? departureDate,
  ) async {
    return xResultHandler(() async {
      final result = await api.fetchBusBySchedule(id, departureDate);
      return result.data;
    });
  }

  @override
  Future<XResult<DetailRouteModel?>> fetchRouteById(int id) async {
    return xResultHandler(() async {
      final result = await api.fetchRouteDetail(id);
      return result.data;
    });
  }
}
