import 'package:json_annotation/json_annotation.dart';

part 'verify_payment_model.g.dart';

/*
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
}*/
@JsonSerializable()
class VerifyPaymentModel {
  final bool? success;
  final Result? result;

  VerifyPaymentModel({this.success, this.result});

  factory VerifyPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyPaymentModelToJson(this);
}

@JsonSerializable()
class Result {
  final String? message;
  final Payment? payment;

  Result({this.message, this.payment});

  factory Result.fromJson(Map<String, dynamic> json) =>
      _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Payment {
  final int? id;
  final int? bookingId;
  final double? amount;
  final String? method;
  final String? transactionId;
  final String? status;
  final DateTime? paidAt;

  Payment({
    this.id,
    this.bookingId,
    this.amount,
    this.method,
    this.transactionId,
    this.status,
    this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
