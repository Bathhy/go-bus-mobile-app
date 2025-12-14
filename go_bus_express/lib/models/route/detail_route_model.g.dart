// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteListResponseModel _$RouteListResponseModelFromJson(
  Map<String, dynamic> json,
) => RouteListResponseModel(
  schedules: (json['schedules'] as List<dynamic>?)
      ?.map((e) => DetailRouteModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: (json['count'] as num?)?.toInt(),
  summary: json['summary'] == null
      ? null
      : RouteSummary.fromJson(json['summary'] as Map<String, dynamic>),
  route: json['route'] == null
      ? null
      : RouteModel.fromJson(json['route'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RouteListResponseModelToJson(
  RouteListResponseModel instance,
) => <String, dynamic>{
  'schedules': instance.schedules,
  'count': instance.count,
  'summary': instance.summary,
  'route': instance.route,
};

DetailRouteModel _$DetailRouteModelFromJson(Map<String, dynamic> json) =>
    DetailRouteModel(
      id: (json['id'] as num?)?.toInt(),
      busId: (json['busId'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      departureDate: json['departureDate'] == null
          ? null
          : DateTime.parse(json['departureDate'] as String),
      arrivalTime: json['arrivalTime'] as String?,
      departureTime: json['departureTime'] as String?,
      bus: json['bus'] == null
          ? null
          : BusModel.fromJson(json['bus'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailRouteModelToJson(DetailRouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'busId': instance.busId,
      'price': instance.price,
      'departureDate': instance.departureDate?.toIso8601String(),
      'arrivalTime': instance.arrivalTime,
      'departureTime': instance.departureTime,
      'bus': instance.bus,
    };

BusModel _$BusModelFromJson(Map<String, dynamic> json) => BusModel(
  id: (json['id'] as num?)?.toInt(),
  routeId: (json['routeId'] as num?)?.toInt(),
  busNumber: json['busNumber'] as String?,
  busType: json['busType'] as String?,
  totalSeats: (json['totalSeats'] as num?)?.toInt(),
  layoutId: (json['layoutId'] as num?)?.toInt(),
  route: json['route'] == null
      ? null
      : AllRouteModel.fromJson(json['route'] as Map<String, dynamic>),
  availableSeats: (json['availableSeats'] as num?)?.toInt(),
  bookedSeats: (json['bookedSeats'] as num?)?.toInt(),
);

Map<String, dynamic> _$BusModelToJson(BusModel instance) => <String, dynamic>{
  'id': instance.id,
  'routeId': instance.routeId,
  'busNumber': instance.busNumber,
  'busType': instance.busType,
  'totalSeats': instance.totalSeats,
  'layoutId': instance.layoutId,
  'route': instance.route,
  'availableSeats': instance.availableSeats,
  'bookedSeats': instance.bookedSeats,
};

RouteSummary _$RouteSummaryFromJson(Map<String, dynamic> json) => RouteSummary(
  totalSchedules: (json['totalSchedules'] as num?)?.toInt(),
  totalAvailableSeats: (json['totalAvailableSeats'] as num?)?.toInt(),
  totalBookedSeats: (json['totalBookedSeats'] as num?)?.toInt(),
);

Map<String, dynamic> _$RouteSummaryToJson(RouteSummary instance) =>
    <String, dynamic>{
      'totalSchedules': instance.totalSchedules,
      'totalAvailableSeats': instance.totalAvailableSeats,
      'totalBookedSeats': instance.totalBookedSeats,
    };

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => RouteModel(
  id: (json['id'] as num?)?.toInt(),
  origin: json['origin'] as String?,
  destination: json['destination'] as String?,
  distanceKm: (json['distanceKm'] as num?)?.toInt(),
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'origin': instance.origin,
      'destination': instance.destination,
      'distanceKm': instance.distanceKm,
      'durationMinutes': instance.durationMinutes,
    };
