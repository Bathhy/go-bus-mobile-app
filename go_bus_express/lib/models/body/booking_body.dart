import 'package:json_annotation/json_annotation.dart';

part 'booking_body.g.dart';

@JsonSerializable()
class BookingBody {
  final int? scheduleId;
  final List<int>? seatIds;
  final String? passengerNumber;

  BookingBody({this.scheduleId, this.seatIds, this.passengerNumber});

  factory BookingBody.fromJson(Map<String, dynamic> json) =>
      _$BookingBodyFromJson(json);

  Map<String, dynamic> toJson() => _$BookingBodyToJson(this);
}
