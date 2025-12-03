import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  final logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('🚀 REQUEST[${options.method}] => ${options.uri}');
    logger.d('Headers: ${options.headers}');
    logger.d('Body: ${options.data}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}');
    logger.d('Data: ${response.data}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.uri}');
    logger.e('Message: ${err.message}');
    return handler.next(err);
  }
}
