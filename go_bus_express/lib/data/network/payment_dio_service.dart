import 'package:dio/dio.dart';

import '../../core/network/connectivity_interceptor.dart';
import '../../core/storage/local_repository.dart';
import 'Interceptor/token_refresh_interceptor.dart';
import 'Interceptor/x_app_interceptor.dart';
import 'network_constant.dart';

/// Dedicated Dio instance for [PaymentBakongApi].
///
/// `/payments/bakong/checking-transaction` holds the HTTP connection open
/// while the backend polls Bakong for payment confirmation (up to ~5 minutes).
/// Using the default 30-second [DioService] would cause a
/// [DioExceptionType.receiveTimeout] before the payment completes.
///
/// Only [PaymentBakongApi] should be wired to this service.
/// All other APIs (including [WalletPaymentApi]) use the standard [DioService].
class PaymentDioService {
  late Dio _dio;
  final LocalRepository _localRepository;

  PaymentDioService(this._localRepository) {
    _dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstant.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 6),
        responseType: ResponseType.json,
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.addAll([
      ConnectivityInterceptor(),
      XInterceptor(_localRepository),
      TokenRefreshInterceptor(
        dio: _dio,
        localRepository: _localRepository,
        baseUrl: NetworkConstant.baseUrl,
      ),
    ]);
  }

  Dio get dio => _dio;
}
