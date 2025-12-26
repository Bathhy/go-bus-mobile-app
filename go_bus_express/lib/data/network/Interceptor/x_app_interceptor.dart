import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_bus_express/data/network/network_constant.dart';
import '../../../core/storage/local_repository.dart';

/// Dio App Interceptor
class XInterceptor extends Interceptor {
  final LocalRepository _localRepository;

  XInterceptor(this._localRepository);

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = _localRepository.getToken();

    options.headers['Content-Type'] = 'application/json';
    options.headers['X-Requested-With'] = 'XMLHttpRequest ';
    options.headers['accepts-version'] = '1.0.0';
    options.headers['Accept-Language'] = 'en';
    options.headers['x-push-token'] = '';

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final method = options.method.toUpperCase();
    debug('$method  ${options.uri}');
    debug('Headers: ${options.headers}');
    debug('Body: ${options.data}\n');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Do something with response data

    debug(
      '''${response.requestOptions.method.toUpperCase()}  ${response.requestOptions.uri} - ''',
    );
    debug("status code${response.statusCode}");
    final res = response.data.toString();
    debug(
      // ignore: prefer_interpolation_to_compose_strings
      '''Response: ${(res.length > 2500) ? res.substring(0, 2500) + '...' : res}\n''',
    );

    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final errorResponse = err.response;

    if (errorResponse != null) {
      // HandleStatusCodeService.instance.startListen(errorResponse);
    }

    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';

    // Log the error request and error message
    debug('onError: ${options.method} request => $requestPath');
    debug('onError: ${err.error}, Message: ${err.message}');
    debug('Status Code ======> : ${err.response?.statusCode},}');

    super.onError(err, handler);
  }

  void debug(String message) {
    debugPrint('[API-debug] $message');
  }
}
