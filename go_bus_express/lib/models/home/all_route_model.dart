import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'all_route_model.g.dart';

@JsonSerializable()
class AllRouteModel {
  final int? id;
  final String? origin;
  final String? destination;
  final double? distanceKm;
  final int? durationMinutes;
  @JsonKey(fromJson: _locationFromJson, toJson: _locationToJson)
  final Location? location;
  final int? busCount;

  AllRouteModel({
    this.id,
    this.origin,
    this.destination,
    this.distanceKm,
    this.durationMinutes,
    this.location,
    this.busCount,
  });

  static Location? _locationFromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(json);
        return Location.fromJson(decoded);
      } catch (e) {
        print('❌ Error parsing location string: $e');
        return null;
      }
    }
    if (json is Map<String, dynamic>) {
      return Location.fromJson(json);
    }
    return null;
  }

  static dynamic _locationToJson(Location? location) {
    return location?.toJson();
  }

  AllRouteModel copyWith({
    int? id,
    String? origin,
    String? destination,
    double? distanceKm,
    int? durationMinutes,
    Location? location,
    int? busCount,
  }) =>
      AllRouteModel(
        id: id ?? this.id,
        origin: origin ?? this.origin,
        destination: destination ?? this.destination,
        distanceKm: distanceKm ?? this.distanceKm,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        location: location ?? this.location,
        busCount: busCount ?? this.busCount,
      );

  factory AllRouteModel.fromJson(Map<String, dynamic> json) =>
      _$AllRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllRouteModelToJson(this);
}

@JsonSerializable()
class Location {
  final double? lat;
  final double? lng;

  Location({
    required this.lat,
    required this.lng,
  });

  Location copyWith({
    double? lat,
    double? lng,
  }) =>
      Location(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
