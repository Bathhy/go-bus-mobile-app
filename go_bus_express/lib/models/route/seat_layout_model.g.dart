// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_layout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeatLayoutModel _$SeatLayoutModelFromJson(Map<String, dynamic> json) =>
    SeatLayoutModel(
      layout: json['layout'] == null
          ? null
          : BusLayoutModel.fromJson(json['layout'] as Map<String, dynamic>),
      seats: (json['seats'] as List<dynamic>?)
          ?.map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeatLayoutModelToJson(SeatLayoutModel instance) =>
    <String, dynamic>{
      'layout': instance.layout?.toJson(),
      'seats': instance.seats?.map((e) => e.toJson()).toList(),
    };

BusLayoutModel _$BusLayoutModelFromJson(Map<String, dynamic> json) =>
    BusLayoutModel(
      id: (json['id'] as num?)?.toInt(),
      busNumber: json['busNumber'] as String?,
      layout: json['layout'] == null
          ? null
          : LayoutInfo.fromJson(json['layout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusLayoutModelToJson(BusLayoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'busNumber': instance.busNumber,
      'layout': instance.layout?.toJson(),
    };

LayoutInfo _$LayoutInfoFromJson(Map<String, dynamic> json) => LayoutInfo(
  id: (json['id'] as num?)?.toInt(),
  layout: (json['layout'] as List<dynamic>?)
      ?.map((e) => (e as List<dynamic>).map((e) => e as String?).toList())
      .toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  name: json['name'] as String?,
);

Map<String, dynamic> _$LayoutInfoToJson(LayoutInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'layout': instance.layout,
      'createdAt': instance.createdAt?.toIso8601String(),
      'name': instance.name,
    };

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
  id: (json['id'] as num?)?.toInt(),
  seatNumber: json['seatNumber'] as String?,
  busId: (json['busId'] as num?)?.toInt(),
  status: json['status'] as String?,
);

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
  'id': instance.id,
  'seatNumber': instance.seatNumber,
  'busId': instance.busId,
  'status': instance.status,
};
