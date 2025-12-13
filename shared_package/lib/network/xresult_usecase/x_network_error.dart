abstract class XNetworkError {
  final String? message;
  final int? statusCode;

  XNetworkError({this.message, this.statusCode});

  String get displayMessage => message ?? defaultMessage;

  String get defaultMessage;
}

class UnauthorizedError extends XNetworkError {
  UnauthorizedError({super.message, super.statusCode});

  @override
  String get defaultMessage => 'Session expired. Please login again.';
}

class ForbiddenError extends XNetworkError {
  ForbiddenError({super.message, super.statusCode});

  @override
  String get defaultMessage =>
      'You don\'t have permission to access this resource.';
}

class NetworkTimeOut extends XNetworkError {
  NetworkTimeOut({super.message, super.statusCode});

  @override
  String get defaultMessage => 'Connection timeout. Please try again.';
}

class ServerError extends XNetworkError {
  ServerError({super.message, super.statusCode});

  @override
  String get defaultMessage => 'Server error occurred. Please try again later.';
}

class NetworkError extends XNetworkError {
  NetworkError({super.message, super.statusCode});

  @override
  String get defaultMessage =>
      'No internet connection. Please check your network.';
}

class SomethingWrongError extends XNetworkError {
  SomethingWrongError({super.message, super.statusCode});

  @override
  String get defaultMessage => 'Something went wrong. Please try again.';
}
