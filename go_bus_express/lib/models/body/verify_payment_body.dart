import 'package:json_annotation/json_annotation.dart';

part 'verify_payment_body.g.dart';

@JsonSerializable()
class VerifyPaymentBody {
  final String? md5;
  @JsonKey(name: 'booking_id')
  final int? bookingId;

  VerifyPaymentBody({this.md5, this.bookingId});

  factory VerifyPaymentBody.fromJson(Map<String, dynamic> json) =>
      _$VerifyPaymentBodyFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyPaymentBodyToJson(this);
}
