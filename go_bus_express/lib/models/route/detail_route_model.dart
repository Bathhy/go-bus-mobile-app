import 'package:go_bus_express/models/home/all_route_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_route_model.g.dart';

@JsonSerializable()
class RouteListResponseModel {
  @JsonKey(name: 'content')
  final List<DetailRouteModel>? schedules;
  final int? totalElements;
  final int? totalPages;
  final RouteSummary? summary;
  final RouteModel? route;

  const RouteListResponseModel({
    this.schedules,
    this.totalElements,
    this.totalPages,
    this.summary,
    this.route,
  });

  factory RouteListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RouteListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteListResponseModelToJson(this);
}

@JsonSerializable()
class DetailRouteModel {
  final int? id;
  final int? busId;
  final String? busNumber;
  final double? price;
  @JsonKey(name: 'departureDateTime')
  final DateTime? departureDate;
  @JsonKey(name: 'arrivalDateTime')
  final DateTime? arrivalDate;
  final RouteModel? route;
  final String? bookingIds;

  const DetailRouteModel({
    this.id,
    this.busId,
    this.busNumber,
    this.price,
    this.departureDate,
    this.arrivalDate,
    this.route,
    this.bookingIds,
  });

  // Helper getters for time strings
  String? get departureTime => departureDate != null 
      ? '${departureDate!.hour.toString().padLeft(2, '0')}:${departureDate!.minute.toString().padLeft(2, '0')}'
      : null;
  
  String? get arrivalTime => arrivalDate != null 
      ? '${arrivalDate!.hour.toString().padLeft(2, '0')}:${arrivalDate!.minute.toString().padLeft(2, '0')}'
      : null;

  factory DetailRouteModel.fromJson(Map<String, dynamic> json) =>
      _$DetailRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailRouteModelToJson(this);
}

@JsonSerializable()
class BusModel {
  final int? id;
  final int? routeId;
  final String? busNumber;
  final String? busType;
  final int? totalSeats;
  final int? layoutId;
  final AllRouteModel? route;

  // New variables added here
  final int? availableSeats;
  final int? bookedSeats;

  BusModel({
    this.id,
    this.routeId,
    this.busNumber,
    this.busType,
    this.totalSeats,
    this.layoutId,
    this.route,
    this.availableSeats,
    this.bookedSeats,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) =>
      _$BusModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusModelToJson(this);
}

@JsonSerializable()
class RouteSummary {
  final int? totalSchedules;
  final int? totalAvailableSeats;
  final int? totalBookedSeats;

  RouteSummary({
    this.totalSchedules,
    this.totalAvailableSeats,
    this.totalBookedSeats,
  });

  factory RouteSummary.fromJson(Map<String, dynamic> json) =>
      _$RouteSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$RouteSummaryToJson(this);
}

@JsonSerializable()
class RouteModel {
  final int? id;
  final String? origin;
  final String? destination;
  final double? distanceKm;
  final int? durationMinutes;
  final String? location;
  final int? busCount;

  RouteModel({
    this.id,
    this.origin,
    this.destination,
    this.distanceKm,
    this.durationMinutes,
    this.location,
    this.busCount,
  });

  RouteModel copyWith({
    int? id,
    String? origin,
    String? destination,
    double? distanceKm,
    int? durationMinutes,
    String? location,
    int? busCount,
  }) => RouteModel(
    id: id ?? this.id,
    origin: origin ?? this.origin,
    destination: destination ?? this.destination,
    distanceKm: distanceKm ?? this.distanceKm,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    location: location ?? this.location,
    busCount: busCount ?? this.busCount,
  );

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}
