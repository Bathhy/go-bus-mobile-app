// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailRouteModel _$DetailRouteModelFromJson(Map<String, dynamic> json) =>
    DetailRouteModel(
      id: (json['id'] as num?)?.toInt(),
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toInt(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      buses: (json['buses'] as List<dynamic>?)
          ?.map((e) => Bus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DetailRouteModelToJson(DetailRouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'origin': instance.origin,
      'destination': instance.destination,
      'distanceKm': instance.distanceKm,
      'durationMinutes': instance.durationMinutes,
      'location': instance.location,
      'buses': instance.buses,
    };

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
  id: (json['id'] as num?)?.toInt(),
  routeId: (json['routeId'] as num?)?.toInt(),
  busNumber: json['busNumber'] as String?,
  busType: json['busType'] as String?,
  totalSeats: (json['totalSeats'] as num?)?.toInt(),
  layoutId: (json['layoutId'] as num?)?.toInt(),
);

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
  'id': instance.id,
  'routeId': instance.routeId,
  'busNumber': instance.busNumber,
  'busType': instance.busType,
  'totalSeats': instance.totalSeats,
  'layoutId': instance.layoutId,
};
