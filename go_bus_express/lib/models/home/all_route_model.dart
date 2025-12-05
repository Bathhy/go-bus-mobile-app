import 'package:json_annotation/json_annotation.dart';

part 'all_route_model.g.dart';

@JsonSerializable()
class AllRouteModel {
  final int? id;
  final String? origin;
  final String? destination;
  final int? distanceKm;
  final int? durationMinutes;
  final Location? location;

  AllRouteModel({
   this.id,
  this.origin,
   this.destination,
   this.distanceKm,
    this.durationMinutes,
    this.location,
  });

  AllRouteModel copyWith({
    int? id,
    String? origin,
    String? destination,
    int? distanceKm,
    int? durationMinutes,
    Location? location,
  }) =>
      AllRouteModel(
        id: id ?? this.id,
        origin: origin ?? this.origin,
        destination: destination ?? this.destination,
        distanceKm: distanceKm ?? this.distanceKm,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        location: location ?? this.location,
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
