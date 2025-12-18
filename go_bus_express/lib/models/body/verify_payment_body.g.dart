// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_payment_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyPaymentBody _$VerifyPaymentBodyFromJson(Map<String, dynamic> json) =>
    VerifyPaymentBody(
      md5: json['md5'] as String?,
      bookingId: (json['booking_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VerifyPaymentBodyToJson(VerifyPaymentBody instance) =>
    <String, dynamic>{'md5': instance.md5, 'booking_id': instance.bookingId};
