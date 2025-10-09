import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_package/network/xresult_usecase/x_network_error.dart';

sealed class XResult<T> {
  factory XResult.success(T data) = Success<T>;
  factory XResult.error(XNetworkError error) = Error<T>;
}

class Success<T> implements XResult<T> {
  final T data;
  Success(this.data);
}

class Error<T> implements XResult<T> {
  final XNetworkError error;
  Error(this.error);
}

Future<XResult<T>> xResultHandler<T>(Future<T> Function() emitResult) async {
  try {
    final result = await emitResult();
    return XResult.success(result);
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return XResult.error(NetworkTimeOut());
      case DioExceptionType.sendTimeout:
        return XResult.error(NetworkTimeOut());
      case DioExceptionType.receiveTimeout:
        return XResult.error(NetworkTimeOut());
      case DioExceptionType.badCertificate:
        return XResult.error(ServerError());
      case DioExceptionType.badResponse:
        return XResult.error(ServerError());
      case DioExceptionType.cancel:
        return XResult.error(SomethingWrongError());
      case DioExceptionType.connectionError:
        return XResult.error(NetworkError());
      case DioExceptionType.unknown:
        return XResult.error(SomethingWrongError());
    }
  } catch (e) {
    log(e.toString());
    return XResult.error(SomethingWrongError());
  }
}
