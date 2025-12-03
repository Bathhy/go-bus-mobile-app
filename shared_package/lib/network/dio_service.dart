import 'package:dio/dio.dart';
import 'package:shared_package/network/Interceptor/x_app_interceptor.dart';
import 'package:shared_package/network/network_constant.dart';

class DioService {
  late Dio _dio;

  // final sharedPrefs = MySharePrefs.instance;

  DioService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstant.productionUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        contentType: "application/json",
      ),
    )
      ..interceptors.addAll([XInterceptor()]);
  }

  // getter for access _dio object
  Dio get dio => _dio;
}
