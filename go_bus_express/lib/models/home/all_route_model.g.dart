// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllRouteModel _$AllRouteModelFromJson(Map<String, dynamic> json) =>
    AllRouteModel(
      id: (json['id'] as num?)?.toInt(),
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      location: AllRouteModel._locationFromJson(json['location']),
      busCount: (json['busCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AllRouteModelToJson(AllRouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'origin': instance.origin,
      'destination': instance.destination,
      'distanceKm': instance.distanceKm,
      'durationMinutes': instance.durationMinutes,
      'location': AllRouteModel._locationToJson(instance.location),
      'busCount': instance.busCount,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'lat': instance.lat,
  'lng': instance.lng,
};
