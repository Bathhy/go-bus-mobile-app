import 'package:dio/dio.dart';
import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:go_bus_express/models/route/detail_route_model.dart';
import 'package:retrofit/http.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';
import 'package:shared_package/network/base_response.dart';

part 'go_bus_api.g.dart';

@RestApi()
abstract class GoBusApi {
  factory GoBusApi(Dio dio, {String baseUrl}) = _GoBusApi;

  @GET('/profile/getProfile')
  Future<BaseResponse<ProfileModel>> fetchProfile();

  @GET('/route/{id}')
  Future<BaseResponse<DetailRouteModel>> fetchRouteDetail(@Path('id') int id);

  @GET('/route')
  Future<BaseResponse<List<DetailRouteModel>>> fetchRoutes();
}
