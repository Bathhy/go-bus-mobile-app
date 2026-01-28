import 'package:dio/dio.dart';
import 'package:go_bus_express/models/body/update_profile_body.dart';
import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:go_bus_express/models/route/detail_route_model.dart';
import 'package:go_bus_express/models/route/seat_layout_model.dart';
import 'package:retrofit/http.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';
import 'package:shared_package/network/base_response.dart';

import '../../models/home/all_route_model.dart';

part 'go_bus_api.g.dart';

@RestApi()
abstract class GoBusApi {
  factory GoBusApi(Dio dio, {String baseUrl}) = _GoBusApi;

  @GET('/profile/getProfile')
  Future<BaseResponse<ProfileModel>> fetchProfile();

  @GET('/bus/bySchedule/{destinationId}')
  Future<BaseResponse<RouteListResponseModel>> fetchBusBySchedule(
    @Path('destinationId') int destinationId, {
    @Query('departureDate') String? departureDate,
  });

  @GET('/bus/seat/seatAndLayout')
  Future<BaseResponse<SeatLayoutModel>> fetchBusSeat(
    @Query("scheduleId") int scheduleId,
    @Query("busId") int busId,
  );

  @GET('/route/{id}')
  Future<BaseResponse<DetailRouteModel>> fetchRouteDetail(@Path('id') int id);

  @GET('/route')
  Future<BaseResponse<List<AllRouteModel>>> fetchRoutes();

  @PUT('/profile/updateProfile')
  @MultiPart()
  Future<BaseResponse<ProfileModel>> updateProfile({
    @Part(name: "email") required String email,
    @Part(name: "fullName") required String fullName,
    @Part(name: "phone") required String phone,
    @Part(name: "image") MultipartFile? image,
  });
}
