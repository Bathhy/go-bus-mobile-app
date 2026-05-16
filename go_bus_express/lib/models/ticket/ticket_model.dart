import 'package:json_annotation/json_annotation.dart';

part 'ticket_model.g.dart';

@JsonSerializable()
class TicketModel {
  List<TicketItem>? content;

  TicketModel({this.content});

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketModelToJson(this);
}

@JsonSerializable()
class TicketItem {
  int? id;
  BookingDetail? bookingDetailResponse;
  String? qrCode;
  DateTime? issuedAt;

  TicketItem({this.id, this.bookingDetailResponse, this.qrCode, this.issuedAt});

  factory TicketItem.fromJson(Map<String, dynamic> json) =>
      _$TicketItemFromJson(json);

  Map<String, dynamic> toJson() => _$TicketItemToJson(this);
}

@JsonSerializable()
class BookingDetail {
  int? id;
  String? bookingStatus;
  String? paymentStatus;
  String? paymentMethod;
  double? totalAmount;
  DateTime? createdAt;
  String? phoneNumber;
  User? user;
  Schedule? schedule;
  List<Seat>? seats;
  Payment? payment;
  TicketInfo? ticket;

  BookingDetail({
    this.id,
    this.bookingStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.totalAmount,
    this.createdAt,
    this.phoneNumber,
    this.user,
    this.schedule,
    this.seats,
    this.payment,
    this.ticket,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailToJson(this);
}

@JsonSerializable()
class Schedule {
  int? id;
  int? busId;
  String? busNumber;
  String? busType;
  String? origin;
  String? destination;
  DateTime? departureDateTime;
  DateTime? arrivalDateTime;
  double? price;

  Schedule({
    this.id,
    this.busId,
    this.busNumber,
    this.busType,
    this.origin,
    this.destination,
    this.departureDateTime,
    this.arrivalDateTime,
    this.price,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

@JsonSerializable()
class Seat {
  int? seatId;
  String? seatNumber;
  String? seatType;
  String? passengerNumber;

  Seat({this.seatId, this.seatNumber, this.seatType, this.passengerNumber});

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);
}

@JsonSerializable()
class Payment {
  int? id;
  int? bookingId;
  double? amount;
  String? method;
  String? transactionId;
  String? status;
  DateTime? paidAt;
  String? walletTransactionId;

  Payment({
    this.id,
    this.bookingId,
    this.amount,
    this.method,
    this.transactionId,
    this.status,
    this.paidAt,
    this.walletTransactionId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class TicketInfo {
  int? id;
  int? bookingId;
  String? qrCode;
  DateTime? issuedAt;

  TicketInfo({this.id, this.bookingId, this.qrCode, this.issuedAt});

  factory TicketInfo.fromJson(Map<String, dynamic> json) =>
      _$TicketInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TicketInfoToJson(this);
}

@JsonSerializable()
class User {
  final int? id;
  final String? fullName;
  final String? email;
  final String? phone;

  const User({this.id, this.fullName, this.email, this.phone});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
