// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentBody _$PaymentBodyFromJson(Map<String, dynamic> json) => PaymentBody(
  bookingId: (json['bookingId'] as num).toInt(),
  currency: json['currency'] as String? ?? 'KHR',
);

Map<String, dynamic> _$PaymentBodyToJson(PaymentBody instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'currency': instance.currency,
    };
