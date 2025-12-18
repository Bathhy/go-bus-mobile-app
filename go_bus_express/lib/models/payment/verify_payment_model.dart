import 'package:json_annotation/json_annotation.dart';

part 'verify_payment_model.g.dart';

@JsonSerializable()
class VerifyPaymentModel {
  final int? bookingId;
  final double? amount;
  final String? method;
  final String? transactionId;
  final String? status;
  final String? paidAt;

  VerifyPaymentModel({
    this.bookingId,
    this.amount,
    this.method,
    this.transactionId,
    this.status,
    this.paidAt,
  });

  factory VerifyPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyPaymentModelToJson(this);
}
