import 'package:dio/dio.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';
import 'package:go_bus_express/models/auth/auth_model.dart';
import 'package:retrofit/http.dart';

import '../../models/body/auth_body.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/login')
  Future<AuthModel> login({@Body() required LoginBody body});
}
