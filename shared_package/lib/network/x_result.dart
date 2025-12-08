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
    // Extract backend error message
    String? backendMessage;

    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        backendMessage =
            data['message'] ?? data['error'] ?? data['msg'] ?? data['detail'];
      } else if (data is String) {
        backendMessage = data;
      }
    }

    final statusCode = e.response?.statusCode;

    // Handle unauthorized specifically
    if (statusCode == 401) {
      return XResult.error(
        UnauthorizedError(message: backendMessage, statusCode: statusCode),
      );
    }

    // Handle forbidden
    if (statusCode == 403) {
      return XResult.error(
        ForbiddenError(message: backendMessage, statusCode: statusCode),
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return XResult.error(NetworkTimeOut(message: backendMessage));
      case DioExceptionType.sendTimeout:
        return XResult.error(NetworkTimeOut(message: backendMessage));
      case DioExceptionType.receiveTimeout:
        return XResult.error(NetworkTimeOut(message: backendMessage));
      case DioExceptionType.badCertificate:
        return XResult.error(ServerError(message: backendMessage));
      case DioExceptionType.badResponse:
        return XResult.error(
          ServerError(message: backendMessage, statusCode: statusCode),
        );
      case DioExceptionType.cancel:
        return XResult.error(SomethingWrongError(message: backendMessage));
      case DioExceptionType.connectionError:
        return XResult.error(NetworkError(message: backendMessage));
      case DioExceptionType.unknown:
        return XResult.error(
          SomethingWrongError(message: backendMessage ?? e.message),
        );
    }
  } catch (e) {
    log(e.toString());
    return XResult.error(SomethingWrongError(message: e.toString()));
  }
}
