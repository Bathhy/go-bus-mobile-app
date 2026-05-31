import 'package:dio/dio.dart';
import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:go_bus_express/models/route/detail_route_model.dart';
import 'package:go_bus_express/models/route/seat_layout_model.dart';
import 'package:retrofit/http.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';
import 'package:shared_package/network/base_response.dart';

import '../../models/body/update_profile_body.dart';
import '../../models/home/all_route_model.dart';
import '../../models/profile/profile_image_url_model.dart';

part 'go_bus_api.g.dart';

@RestApi()
abstract class GoBusApi {
  factory GoBusApi(Dio dio, {String baseUrl}) = _GoBusApi;

  @GET('/users/profile')
  Future<BaseResponse<ProfileModel>> fetchProfile();

  // @GET('/bus/bySchedule/{destinationId}')
  // Future<BaseResponse<RouteListResponseModel>> fetchBusBySchedule(
  //   @Path('destinationId') int destinationId, {
  //   @Query('departureDate') String? departureDate,
  // });

  //  @GET('/schedules/{destinationId}/filter/specification')
  // Future<BaseResponse<RouteListResponseModel>> fetchBusBySchedule(
  //   @Path('destinationId') int destinationId, {
  //   @Query('departureDate') String? departureDate,
  // });

  @GET('/schedules/filter/specification')
  Future<BaseResponse<RouteListResponseModel>> fetchBusBySchedule(
    // @Path('destinationId') int destinationId, {
    // @Query('departureDate') String? departureDate,
    @Query('routeId') int destinationId,
    @Query('fromDate') String? departureDate,
  );

  @GET('/schedule-seats/schedule/{scheduleId}')
  Future<BaseResponse<SeatLayoutModel>> fetchBusSeat(
    @Path("scheduleId") int scheduleId,    
  );

  @GET('/route/{id}')
  Future<BaseResponse<DetailRouteModel>> fetchRouteDetail(@Path('id') int id);

  @GET('/routes')
  Future<BaseResponse<List<AllRouteModel>>> fetchRoutes();

  @PUT('/users/current-user')
  Future<BaseResponse<ProfileModel>> updateProfile(
    @Body() UpdateProfileBody body,
  );

  @POST('/profile/image')
  @MultiPart()
  Future<BaseResponse<ProfileModel>> uploadProfileImage({
    @Part(name: "file") required MultipartFile file,
  });

  @GET('/profile/image/url')
  Future<BaseResponse<ProfileImageUrlModel>> fetchProfileImageUrl();
}
