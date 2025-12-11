// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteListResponseModel _$RouteListResponseModelFromJson(
  Map<String, dynamic> json,
) => RouteListResponseModel(
  route: (json['route'] as List<dynamic>?)
      ?.map((e) => DetailRouteModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: (json['count'] as num?)?.toInt(),
  summary: json['summary'] == null
      ? null
      : RouteSummary.fromJson(json['summary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RouteListResponseModelToJson(
  RouteListResponseModel instance,
) => <String, dynamic>{
  'route': instance.route,
  'count': instance.count,
  'summary': instance.summary,
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
