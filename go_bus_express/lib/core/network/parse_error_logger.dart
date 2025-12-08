import 'package:dio/dio.dart';

class ParseErrorLogger {
  void logError(Object error, StackTrace stackTrace, RequestOptions options) {
    print('❌ API Error: $error');
    print('📍 URL: ${options.uri}');
    print('📋 StackTrace: $stackTrace');
  }
}
