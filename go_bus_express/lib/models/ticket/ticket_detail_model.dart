
import 'package:json_annotation/json_annotation.dart';
part 'ticket_detail_model.g.dart';

@JsonSerializable()
class TicketDetailModel {
    int? id;
    int? bookingId;
    String? qrCode;
    DateTime? issuedAt;
    Booking? booking;

    TicketDetailModel({
        this.id,
        this.bookingId,
        this.qrCode,
        this.issuedAt,
        this.booking,
    });

    factory TicketDetailModel.fromJson(Map<String, dynamic> json) => _$TicketDetailModelFromJson(json);
    Map<String, dynamic> toJson() => _$TicketDetailModelToJson(this);

}


@JsonSerializable()
class Booking {
    int? id;
    int? userId;
    int? scheduleId;
    String? bookingStatus;
    int? totalAmount;
    dynamic promoId;
    String? paymentStatus;
    DateTime? createdAt;
    Schedule? schedule;

    Booking({
        this.id,
        this.userId,
        this.scheduleId,
        this.bookingStatus,
        this.totalAmount,
        this.promoId,
        this.paymentStatus,
        this.createdAt,
        this.schedule,
    });

    factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
    Map<String, dynamic> toJson() => _$BookingToJson(this);

}

@JsonSerializable()
class Schedule {
    int? id;
    int? busId;
    int? price;
    DateTime? departureDate;
    DateTime? arrivalTime;
    String? departureTime;
    Bus? bus;

    Schedule({
        this.id,
        this.busId,
        this.price,
        this.departureDate,
        this.arrivalTime,
        this.departureTime,
        this.bus,
    });

    factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
    Map<String, dynamic> toJson() => _$ScheduleToJson(this);

}

@JsonSerializable()
class Bus {
    int? id;
    int? routeId;
    String? busNumber;
    String? busType;
    int? totalSeats;
    int? layoutId;
    Route? route;

    Bus({
        this.id,
        this.routeId,
        this.busNumber,
        this.busType,
        this.totalSeats,
        this.layoutId,
        this.route,
    });

    factory Bus.fromJson(Map<String, dynamic> json) => _$BusFromJson(json);
    Map<String, dynamic> toJson() => _$BusToJson(this);

}

@JsonSerializable()
class Route {
    int? id;
    String? origin;
    String? destination;
    int? distanceKm;
    int? durationMinutes;
    dynamic location;

    Route({
        this.id,
        this.origin,
        this.destination,
        this.distanceKm,
        this.durationMinutes,
        this.location,
    });

    factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);
    Map<String, dynamic> toJson() => _$RouteToJson(this);

}
