
import 'package:json_annotation/json_annotation.dart';
part 'ticket_detail_model.g.dart';

@JsonSerializable()
class TicketDetailModel {
    int? id;
    @JsonKey(name: 'bookingDetailResponse')
    BookingDetailResponse? bookingDetailResponse;
    String? qrCode;
    DateTime? issuedAt;

    TicketDetailModel({
        this.id,
        this.bookingDetailResponse,
        this.qrCode,
        this.issuedAt,
    });

    factory TicketDetailModel.fromJson(Map<String, dynamic> json) => _$TicketDetailModelFromJson(json);
    Map<String, dynamic> toJson() => _$TicketDetailModelToJson(this);
}

@JsonSerializable()
class BookingDetailResponse {
    int? id;
    String? bookingStatus;
    String? paymentStatus;
    String? paymentMethod;
    double? totalAmount;
    DateTime? createdAt;
    String? phoneNumber;
    User? user;
    Schedule? schedule;
    dynamic promo;
    List<Seat>? seats;
    Payment? payment;
    Ticket? ticket;

    BookingDetailResponse({
        this.id,
        this.bookingStatus,
        this.paymentStatus,
        this.paymentMethod,
        this.totalAmount,
        this.createdAt,
        this.phoneNumber,
        this.user,
        this.schedule,
        this.promo,
        this.seats,
        this.payment,
        this.ticket,
    });

    factory BookingDetailResponse.fromJson(Map<String, dynamic> json) => _$BookingDetailResponseFromJson(json);
    Map<String, dynamic> toJson() => _$BookingDetailResponseToJson(this);
}

@JsonSerializable()
class User {
    int? id;
    String? fullName;
    String? email;
    String? phone;

    User({
        this.id,
        this.fullName,
        this.email,
        this.phone,
    });

    factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Schedule {
    int? id;
    int? busId;
    String? busNumber;
    String? busType;
    DateTime? departureDateTime;
    DateTime? arrivalDateTime;
    double? price;
    String? origin;
    String? destination;

    Schedule({
        this.id,
        this.busId,
        this.busNumber,
        this.busType,
        this.departureDateTime,
        this.arrivalDateTime,
        this.price,
        this.origin,
        this.destination,
    });

    factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
    Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

@JsonSerializable()
class Seat {
    int? seatId;
    String? seatNumber;
    String? seatType;
    String? passengerNumber;

    Seat({
        this.seatId,
        this.seatNumber,
        this.seatType,
        this.passengerNumber,
    });

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

    factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
    Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class Ticket {
    int? id;
    int? bookingId;
    String? qrCode;
    DateTime? issuedAt;

    Ticket({
        this.id,
        this.bookingId,
        this.qrCode,
        this.issuedAt,
    });

    factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
    Map<String, dynamic> toJson() => _$TicketToJson(this);
}
