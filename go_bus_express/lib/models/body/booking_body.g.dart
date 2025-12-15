// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingBody _$BookingBodyFromJson(Map<String, dynamic> json) => BookingBody(
  scheduleId: (json['scheduleId'] as num?)?.toInt(),
  seatIds: (json['seatIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  passengerNumber: json['passengerNumber'] as String?,
);

Map<String, dynamic> _$BookingBodyToJson(BookingBody instance) =>
    <String, dynamic>{
      'scheduleId': instance.scheduleId,
      'seatIds': instance.seatIds,
      'passengerNumber': instance.passengerNumber,
    };
