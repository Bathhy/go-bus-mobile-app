import 'package:json_annotation/json_annotation.dart';

part 'refund_request.g.dart';

/// Refund method options sent to the backend.
enum RefundMethod {
  manual('MANUAL'),
  wallet('WALLET');

  /// The key passed to the backend when the user selects this method.
  final String key;
  const RefundMethod(this.key);
}

@JsonSerializable()
class RefundRequest {
  final String reason;
  final String method;

  RefundRequest({
    required this.reason,
    required this.method,
  });

  factory RefundRequest.fromJson(Map<String, dynamic> json) =>
      _$RefundRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefundRequestToJson(this);
}
