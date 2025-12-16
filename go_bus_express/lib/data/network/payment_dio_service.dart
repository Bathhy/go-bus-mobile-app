import 'package:dio/dio.dart';
import 'package:go_bus_express/data/network/Interceptor/x_app_interceptor.dart';

import 'network_constant.dart';

class PaymentDioService {
  late Dio _dio;

  PaymentDioService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstant.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        contentType: "application/json",
      ),
    )..interceptors.addAll([PaymentXInterceptor()]);
  }

  Dio get dio => _dio;
}
