import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Dio App Interceptor
class XInterceptor extends Interceptor {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Content-Type'] = 'application/json';
    options.headers['X-Requested-With'] = 'XMLHttpRequest ';
    options.headers['accepts-version'] = '1.0.0';
    options.headers['Accept-Language'] = 'en';
    options.headers['x-push-token'] = '';
    // options.headers['Authorization'] = 'Bearer $token';
    options.headers['Authorization'] ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwiZW1haWwiOiJsZW9vbmFyZEBnbWFpbC5jb20iLCJpYXQiOjE3NjQ3ODc2MzcsImV4cCI6MTc2NDc5MTIzN30.Tv4Q2o2tDNVF1ghw-wa8mCfulh7DRqCOdoyodczdRcU';

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
