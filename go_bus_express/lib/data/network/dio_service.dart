import 'package:dio/dio.dart';

import '../../core/network/connectivity_interceptor.dart';
import '../../core/storage/local_repository.dart';
import 'Interceptor/token_refresh_interceptor.dart';
import 'Interceptor/x_app_interceptor.dart';
import 'network_constant.dart';

class DioService {
  late Dio _dio;
  final LocalRepository _localRepository;

  DioService(this._localRepository) {
    _dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstant.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        contentType: "application/json",
      ),
    );

    _dio.interceptors.addAll([
      ConnectivityInterceptor(), // Check internet before request
      XInterceptor(_localRepository), // Add auth headers
      TokenRefreshInterceptor(
        dio: _dio,
        localRepository: _localRepository,
        baseUrl: NetworkConstant.baseUrl,
      ), // Handle token refresh
    ]);
  }

  Dio get dio => _dio;
}
