import 'package:json_annotation/json_annotation.dart';

part 'payment_body.g.dart';

@JsonSerializable()
class PaymentBody {
  final double? amount;
  final String? currency;

  PaymentBody({
    this.amount,
    this.currency,
  });

  factory PaymentBody.fromJson(Map<String, dynamic> json) =>
      _$PaymentBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentBodyToJson(this);
}
