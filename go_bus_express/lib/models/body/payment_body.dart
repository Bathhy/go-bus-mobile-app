import 'package:json_annotation/json_annotation.dart';

part 'payment_body.g.dart';

@JsonSerializable()
class PaymentBody {
  final int bookingId;
  final String currency;

  PaymentBody({
    required this.bookingId,
    this.currency = 'KHR',
  });

  factory PaymentBody.fromJson(Map<String, dynamic> json) =>
      _$PaymentBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentBodyToJson(this);
}
