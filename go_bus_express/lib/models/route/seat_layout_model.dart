import 'package:json_annotation/json_annotation.dart';

part 'seat_layout_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SeatLayoutModel {
  final BusLayoutModel? busLayout;
  final List<Seat>? seat;

  const SeatLayoutModel({
    this.busLayout,
    this.seat,
  });

  factory SeatLayoutModel.fromJson(Map<String, dynamic> json) =>
      _$SeatLayoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$SeatLayoutModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BusLayoutModel {
  final int? id;
  final String? busNumber;
  final LayoutInfo? layout;

  BusLayoutModel({
    this.id,
    this.busNumber,
    this.layout,
  });

  factory BusLayoutModel.fromJson(Map<String, dynamic> json) =>
      _$BusLayoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusLayoutModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LayoutInfo {
  final int? id;
  final List<List<String?>>? layout;
  final DateTime? createdAt;
  final String? name;

  LayoutInfo({
    this.id,
    this.layout,
    this.createdAt,
    this.name,
  });

  factory LayoutInfo.fromJson(Map<String, dynamic> json) =>
      _$LayoutInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LayoutInfoToJson(this);
}

@JsonSerializable()
class Seat {
  final int? id;
  final String? seatNumber;
  final int? busId;
  final String? status;

  Seat({
    this.id,
    this.seatNumber,
    this.busId,
    this.status,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);
}
