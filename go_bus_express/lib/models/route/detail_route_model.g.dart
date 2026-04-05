// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteListResponseModel _$RouteListResponseModelFromJson(
  Map<String, dynamic> json,
) => RouteListResponseModel(
  schedules: (json['content'] as List<dynamic>?)
      ?.map((e) => DetailRouteModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalElements: (json['totalElements'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
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
  'content': instance.schedules,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'summary': instance.summary,
  'route': instance.route,
};

DetailRouteModel _$DetailRouteModelFromJson(Map<String, dynamic> json) =>
    DetailRouteModel(
      id: (json['id'] as num?)?.toInt(),
      busId: (json['busId'] as num?)?.toInt(),
      busNumber: json['busNumber'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      departureDate: json['departureDateTime'] == null
          ? null
          : DateTime.parse(json['departureDateTime'] as String),
      arrivalDate: json['arrivalDateTime'] == null
          ? null
          : DateTime.parse(json['arrivalDateTime'] as String),
      route: json['route'] == null
          ? null
          : RouteModel.fromJson(json['route'] as Map<String, dynamic>),
      bookingIds: json['bookingIds'] as String?,
    );

Map<String, dynamic> _$DetailRouteModelToJson(DetailRouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'busId': instance.busId,
      'busNumber': instance.busNumber,
      'price': instance.price,
      'departureDateTime': instance.departureDate?.toIso8601String(),
      'arrivalDateTime': instance.arrivalDate?.toIso8601String(),
      'route': instance.route,
      'bookingIds': instance.bookingIds,
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
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
  location: json['location'] as String?,
  busCount: (json['busCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'origin': instance.origin,
      'destination': instance.destination,
      'distanceKm': instance.distanceKm,
      'durationMinutes': instance.durationMinutes,
      'location': instance.location,
      'busCount': instance.busCount,
    };
