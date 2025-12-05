import 'package:json_annotation/json_annotation.dart';

import '../home/all_route_model.dart';

part 'detail_route_model.g.dart';

@JsonSerializable()
class DetailRouteModel {
  final int? id;
  final String? origin;
  final String? destination;
  final int? distanceKm;
  final int? durationMinutes;
  final Location? location;
  final List<Bus>? buses;

  DetailRouteModel({
    this.id,
    this.origin,
    this.destination,
    this.distanceKm,
    this.durationMinutes,
    this.location,
    this.buses,
  });

  Welcome copyWith({
    int? id,
    String? origin,
    String? destination,
    int? distanceKm,
    int? durationMinutes,
    Location? location,
    List<Bus>? buses,
  }) =>
      Welcome(
        id: id ?? this.id,
        origin: origin ?? this.origin,
        destination: destination ?? this.destination,
        distanceKm: distanceKm ?? this.distanceKm,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        location: location ?? this.location,
        buses: buses ?? this.buses,
      );

  factory AllRouteModel.fromJson(Map<String, dynamic> json) =>
      _$AllRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllRouteModelToJson(this);
}

class Bus {
  final int? id;
  final int? routeId;
  final String? busNumber;
  final String? busType;
  final int? totalSeats;
  final int? layoutId;

  Bus({
    this.id,
    this.routeId,
    this.busNumber,
    this.busType,
    this.totalSeats,
    this.layoutId,
  });

  Bus copyWith({
    int? id,
    int? routeId,
    String? busNumber,
    String? busType,
    int? totalSeats,
    int? layoutId,
  }) =>
      Bus(
        id: id ?? this.id,
        routeId: routeId ?? this.routeId,
        busNumber: busNumber ?? this.busNumber,
        busType: busType ?? this.busType,
        totalSeats: totalSeats ?? this.totalSeats,
        layoutId: layoutId ?? this.layoutId,
      );
  factory Bus.fromJson(Map<String, dynamic> json) =>
      _$AllRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllRouteModelToJson(this);
}
