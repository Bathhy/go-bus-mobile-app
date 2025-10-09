sealed class XNetworkError {
  String errorMessage();
}

// class NetworkNotFound implements XNetworkError {
//   @override
//   String errorMessage() => "Network Not Found";
// }

class ServerError implements XNetworkError {
  @override
  String errorMessage() => "Server Error";
}

class NetworkError implements XNetworkError {
  @override
  String errorMessage() => "Network Error";
}

class SomethingWrongError implements XNetworkError {
  @override
  String errorMessage() => "Something went Wrong";
}

// class ServiceUnavailable implements XNetworkError {
//   @override
//   String errorMessage() => "Service Unavailable";
// }

class NetworkTimeOut implements XNetworkError {
  @override
  String errorMessage() => "Network TimeOut";
}
