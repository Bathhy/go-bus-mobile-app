import 'package:dio/dio.dart';
import 'package:go_bus_express/data/network/Interceptor/x_app_interceptor.dart';

import '../../core/network/connectivity_interceptor.dart';
import '../../core/storage/local_repository.dart';
import 'network_constant.dart';

class PaymentDioService {
  late Dio _dio;
  final LocalRepository _localRepository;

  PaymentDioService(this._localRepository) {
    _dio =
        Dio(
            BaseOptions(
              baseUrl: NetworkConstant.baseUrlBakong,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              responseType: ResponseType.json,
              contentType: "application/json",
            ),
          )
          ..interceptors.addAll([
            ConnectivityInterceptor(),
            XInterceptor(_localRepository),
          ]);
  }

  Dio get dio => _dio;
}
