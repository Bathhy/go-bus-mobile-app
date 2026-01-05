// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketDetailModel _$TicketDetailModelFromJson(Map<String, dynamic> json) =>
    TicketDetailModel(
      id: (json['id'] as num?)?.toInt(),
      bookingId: (json['bookingId'] as num?)?.toInt(),
      issuedAt: json['issuedAt'] == null
          ? null
          : DateTime.parse(json['issuedAt'] as String),
      booking: json['booking'] == null
          ? null
          : Booking.fromJson(json['booking'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TicketDetailModelToJson(TicketDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'issuedAt': instance.issuedAt?.toIso8601String(),
      'booking': instance.booking,
    };

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  scheduleId: (json['scheduleId'] as num?)?.toInt(),
  bookingStatus: json['bookingStatus'] as String?,
  totalAmount: (json['totalAmount'] as num?)?.toInt(),
  promoId: json['promoId'],
  paymentStatus: json['paymentStatus'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  schedule: json['schedule'] == null
      ? null
      : Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'scheduleId': instance.scheduleId,
  'bookingStatus': instance.bookingStatus,
  'totalAmount': instance.totalAmount,
  'promoId': instance.promoId,
  'paymentStatus': instance.paymentStatus,
  'createdAt': instance.createdAt?.toIso8601String(),
  'schedule': instance.schedule,
};

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
  id: (json['id'] as num?)?.toInt(),
  busId: (json['busId'] as num?)?.toInt(),
  price: (json['price'] as num?)?.toInt(),
  departureDate: json['departureDate'] == null
      ? null
      : DateTime.parse(json['departureDate'] as String),
  arrivalTime: json['arrivalTime'] == null
      ? null
      : DateTime.parse(json['arrivalTime'] as String),
  departureTime: json['departureTime'] as String?,
  bus: json['bus'] == null
      ? null
      : Bus.fromJson(json['bus'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
  'id': instance.id,
  'busId': instance.busId,
  'price': instance.price,
  'departureDate': instance.departureDate?.toIso8601String(),
  'arrivalTime': instance.arrivalTime?.toIso8601String(),
  'departureTime': instance.departureTime,
  'bus': instance.bus,
};

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
  id: (json['id'] as num?)?.toInt(),
  routeId: (json['routeId'] as num?)?.toInt(),
  busNumber: json['busNumber'] as String?,
  busType: json['busType'] as String?,
  totalSeats: (json['totalSeats'] as num?)?.toInt(),
  layoutId: (json['layoutId'] as num?)?.toInt(),
  route: json['route'] == null
      ? null
      : Route.fromJson(json['route'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
  'id': instance.id,
  'routeId': instance.routeId,
  'busNumber': instance.busNumber,
  'busType': instance.busType,
  'totalSeats': instance.totalSeats,
  'layoutId': instance.layoutId,
  'route': instance.route,
};

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
  id: (json['id'] as num?)?.toInt(),
  origin: json['origin'] as String?,
  destination: json['destination'] as String?,
  distanceKm: (json['distanceKm'] as num?)?.toInt(),
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
  location: json['location'],
);

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
  'id': instance.id,
  'origin': instance.origin,
  'destination': instance.destination,
  'distanceKm': instance.distanceKm,
  'durationMinutes': instance.durationMinutes,
  'location': instance.location,
};
