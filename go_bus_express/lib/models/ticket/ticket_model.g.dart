// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => TicketModel(
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  totalTickets: (json['totalTickets'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TicketModelToJson(TicketModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'totalTickets': instance.totalTickets,
      'data': instance.data,
    };

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: (json['id'] as num?)?.toInt(),
  issuedAt: json['issuedAt'] == null
      ? null
      : DateTime.parse(json['issuedAt'] as String),
  booking: json['booking'] == null
      ? null
      : Booking.fromJson(json['booking'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'issuedAt': instance.issuedAt?.toIso8601String(),
  'booking': instance.booking,
};

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
  id: (json['id'] as num?)?.toInt(),
  paymentStatus: json['paymentStatus'] as String?,
  bookingStatus: json['bookingStatus'] as String?,
  schedule: json['schedule'] == null
      ? null
      : Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
  seatCount: (json['seatCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
  'id': instance.id,
  'paymentStatus': instance.paymentStatus,
  'bookingStatus': instance.bookingStatus,
  'schedule': instance.schedule,
  'seatCount': instance.seatCount,
};

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
  bus: json['bus'] == null
      ? null
      : Bus.fromJson(json['bus'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
  'bus': instance.bus,
};

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
  busType: json['busType'] as String?,
  busNumber: json['busNumber'] as String?,
  route: json['route'] == null
      ? null
      : Route.fromJson(json['route'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
  'busType': instance.busType,
  'busNumber': instance.busNumber,
  'route': instance.route,
};

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
  origin: json['origin'] as String?,
  destination: json['destination'] as String?,
);

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
  'origin': instance.origin,
  'destination': instance.destination,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  fullName: json['fullName'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
};
