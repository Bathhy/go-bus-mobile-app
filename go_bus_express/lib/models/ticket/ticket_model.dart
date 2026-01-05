import 'package:json_annotation/json_annotation.dart';
part 'ticket_model.g.dart';

@JsonSerializable()
class TicketModel {
  User? user;
  int? totalTickets;
  List<Datum>? data;

  TicketModel({this.user, this.totalTickets, this.data});

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketModelToJson(this);
}

@JsonSerializable()
class Datum {
  int? id;
  DateTime? issuedAt;
  Booking? booking;

  Datum({this.id, this.issuedAt, this.booking});

    factory Datum.fromJson(Map<String, dynamic> json) =>
      _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}

@JsonSerializable()
class Booking {
  int? id;
  String? paymentStatus;
  String? bookingStatus;
  Schedule? schedule;
  int? seatCount;

  Booking({
    this.id,
    this.paymentStatus,
    this.bookingStatus,
    this.schedule,
    this.seatCount,
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}

@JsonSerializable()
class Schedule {
  Bus? bus;

  Schedule({this.bus});

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

@JsonSerializable()
class Bus {
  String? busType;
  String? busNumber;
  Route? route;

  Bus({this.busType, this.busNumber, this.route});

  factory Bus.fromJson(Map<String, dynamic> json) =>
      _$BusFromJson(json);

  Map<String, dynamic> toJson() => _$BusToJson(this);
}

@JsonSerializable()
class Route {
  String? origin;
  String? destination;

  Route({this.origin, this.destination});

  factory Route.fromJson(Map<String, dynamic> json) =>
      _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}

@JsonSerializable()
class User {
  int? id;
  String? fullName;

  User({this.id, this.fullName});

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
