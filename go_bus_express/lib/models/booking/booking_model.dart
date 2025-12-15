import 'package:json_annotation/json_annotation.dart';
part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
  final int? id;
  final int? userId;
  final int? scheduleId;
  final String? bookingStatus;
  final int? totalAmount;
  final String? promoId;
  final String? paymentStatus;
  final DateTime? createdAt;

  BookingModel({
    this.id,
    this.userId,
    this.scheduleId,
    this.bookingStatus,
    this.totalAmount,
    this.promoId,
    this.paymentStatus,
    this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}
