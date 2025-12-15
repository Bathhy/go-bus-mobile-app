// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentBody _$PaymentBodyFromJson(Map<String, dynamic> json) => PaymentBody(
  amount: (json['amount'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
);

Map<String, dynamic> _$PaymentBodyToJson(PaymentBody instance) =>
    <String, dynamic>{'amount': instance.amount, 'currency': instance.currency};
