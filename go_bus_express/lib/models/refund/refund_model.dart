import 'package:json_annotation/json_annotation.dart';

part 'refund_model.g.dart';

@JsonSerializable()
class RefundPage {
  List<RefundModel>? content;
  int? totalElements;
  int? totalPages;
  bool? last;
  bool? first;

  RefundPage({
    this.content,
    this.totalElements,
    this.totalPages,
    this.last,
    this.first,
  });

  factory RefundPage.fromJson(Map<String, dynamic> json) =>
      _$RefundPageFromJson(json);

  Map<String, dynamic> toJson() => _$RefundPageToJson(this);
}

@JsonSerializable()
class RefundModel {
  int? id;
  int? bookingId;
  double? amount;
  String? reason;
  String? status;
  String? adminNote;
  int? processedBy;
  DateTime? processedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  RefundBooking? booking;
  RefundUser? user;
  RefundSchedule? schedule;
  RefundRoute? route;

  RefundModel({
    this.id,
    this.bookingId,
    this.amount,
    this.reason,
    this.status,
    this.adminNote,
    this.processedBy,
    this.processedAt,
    this.createdAt,
    this.updatedAt,
    this.booking,
    this.user,
    this.schedule,
    this.route,
  });

  factory RefundModel.fromJson(Map<String, dynamic> json) =>
      _$RefundModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefundModelToJson(this);
}

@JsonSerializable()
class RefundBooking {
  int? id;
  String? bookingStatus;
  String? paymentStatus;
  String? paymentMethod;
  double? totalAmount;
  String? phoneNumber;
  DateTime? createdAt;
  List<RefundSeat>? seats;
  dynamic promo;

  RefundBooking({
    this.id,
    this.bookingStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.totalAmount,
    this.phoneNumber,
    this.createdAt,
    this.seats,
    this.promo,
  });

  factory RefundBooking.fromJson(Map<String, dynamic> json) =>
      _$RefundBookingFromJson(json);

  Map<String, dynamic> toJson() => _$RefundBookingToJson(this);
}

@JsonSerializable()
class RefundSeat {
  int? seatId;
  String? passengerNumber;

  RefundSeat({this.seatId, this.passengerNumber});

  factory RefundSeat.fromJson(Map<String, dynamic> json) =>
      _$RefundSeatFromJson(json);

  Map<String, dynamic> toJson() => _$RefundSeatToJson(this);
}

@JsonSerializable()
class RefundUser {
  int? id;
  String? userName;
  String? fullName;
  String? email;
  String? phone;

  RefundUser({this.id, this.userName, this.fullName, this.email, this.phone});

  factory RefundUser.fromJson(Map<String, dynamic> json) =>
      _$RefundUserFromJson(json);

  Map<String, dynamic> toJson() => _$RefundUserToJson(this);
}

@JsonSerializable()
class RefundSchedule {
  int? id;
  DateTime? departureDateTime;
  DateTime? arrivalDateTime;
  double? price;
  int? availableSeats;
  RefundBus? bus;

  RefundSchedule({
    this.id,
    this.departureDateTime,
    this.arrivalDateTime,
    this.price,
    this.availableSeats,
    this.bus,
  });

  factory RefundSchedule.fromJson(Map<String, dynamic> json) =>
      _$RefundScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$RefundScheduleToJson(this);
}

@JsonSerializable()
class RefundBus {
  int? id;
  String? busNumber;
  String? busType;
  int? totalSeats;

  RefundBus({this.id, this.busNumber, this.busType, this.totalSeats});

  factory RefundBus.fromJson(Map<String, dynamic> json) =>
      _$RefundBusFromJson(json);

  Map<String, dynamic> toJson() => _$RefundBusToJson(this);
}

@JsonSerializable()
class RefundRoute {
  int? id;
  String? routeName;
  String? origin;
  String? destination;
  double? distance;
  int? estimatedDuration;

  RefundRoute({
    this.id,
    this.routeName,
    this.origin,
    this.destination,
    this.distance,
    this.estimatedDuration,
  });

  factory RefundRoute.fromJson(Map<String, dynamic> json) =>
      _$RefundRouteFromJson(json);

  Map<String, dynamic> toJson() => _$RefundRouteToJson(this);
}
