// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  scheduleId: (json['scheduleId'] as num?)?.toInt(),
  bookingStatus: json['bookingStatus'] as String?,
  totalAmount: (json['totalAmount'] as num?)?.toInt(),
  promoId: json['promoId'] as String?,
  paymentStatus: json['paymentStatus'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'scheduleId': instance.scheduleId,
      'bookingStatus': instance.bookingStatus,
      'totalAmount': instance.totalAmount,
      'promoId': instance.promoId,
      'paymentStatus': instance.paymentStatus,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
