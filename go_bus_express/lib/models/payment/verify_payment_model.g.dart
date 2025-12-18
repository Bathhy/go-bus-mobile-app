// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyPaymentModel _$VerifyPaymentModelFromJson(Map<String, dynamic> json) =>
    VerifyPaymentModel(
      bookingId: (json['bookingId'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      method: json['method'] as String?,
      transactionId: json['transactionId'] as String?,
      status: json['status'] as String?,
      paidAt: json['paidAt'] as String?,
    );

Map<String, dynamic> _$VerifyPaymentModelToJson(VerifyPaymentModel instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'amount': instance.amount,
      'method': instance.method,
      'transactionId': instance.transactionId,
      'status': instance.status,
      'paidAt': instance.paidAt,
    };
