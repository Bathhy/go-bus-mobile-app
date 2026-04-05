// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_layout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeatLayoutModel _$SeatLayoutModelFromJson(Map<String, dynamic> json) =>
    SeatLayoutModel(
      id: (json['id'] as num?)?.toInt(),
      busNumber: json['busNumber'] as String?,
      plate: json['plate'] as String?,
      model: json['model'] as String?,
      busType: json['busType'] as String?,
      status: json['status'] as String?,
      totalSeats: (json['totalSeats'] as num?)?.toInt(),
      route: json['route'] == null
          ? null
          : AllRouteModel.fromJson(json['route'] as Map<String, dynamic>),
      layout: json['layout'] == null
          ? null
          : LayoutInfo.fromJson(json['layout'] as Map<String, dynamic>),
      seat: (json['seats'] as List<dynamic>?)
          ?.map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeatLayoutModelToJson(SeatLayoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'busNumber': instance.busNumber,
      'plate': instance.plate,
      'model': instance.model,
      'busType': instance.busType,
      'status': instance.status,
      'totalSeats': instance.totalSeats,
      'route': instance.route?.toJson(),
      'layout': instance.layout?.toJson(),
      'seats': instance.seat?.map((e) => e.toJson()).toList(),
    };

BusLayoutModel _$BusLayoutModelFromJson(Map<String, dynamic> json) =>
    BusLayoutModel(
      id: (json['id'] as num?)?.toInt(),
      busNumber: json['busNumber'] as String?,
      layout: json['layout'] == null
          ? null
          : LayoutInfo.fromJson(json['layout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusLayoutModelToJson(BusLayoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'busNumber': instance.busNumber,
      'layout': instance.layout?.toJson(),
    };

LayoutInfo _$LayoutInfoFromJson(Map<String, dynamic> json) => LayoutInfo(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  description: json['description'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  layout: LayoutInfo._layoutFromJson(json['layout']),
);

Map<String, dynamic> _$LayoutInfoToJson(LayoutInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'layout': instance.layout?.toJson(),
    };

LayoutData _$LayoutDataFromJson(Map<String, dynamic> json) => LayoutData(
  rows: (json['rows'] as num?)?.toInt(),
  columns: (json['columns'] as num?)?.toInt(),
  totalSeats: (json['totalSeats'] as num?)?.toInt(),
  aisleColumns: json['aisleColumns'] as String?,
  driverColumn: (json['driverColumn'] as num?)?.toInt(),
  seats: (json['seats'] as List<dynamic>?)
      ?.map(
        (e) => (e as List<dynamic>)
            .map((e) => SeatPosition.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      .toList(),
);

Map<String, dynamic> _$LayoutDataToJson(LayoutData instance) =>
    <String, dynamic>{
      'rows': instance.rows,
      'columns': instance.columns,
      'totalSeats': instance.totalSeats,
      'aisleColumns': instance.aisleColumns,
      'driverColumn': instance.driverColumn,
      'seats': instance.seats,
    };

SeatPosition _$SeatPositionFromJson(Map<String, dynamic> json) => SeatPosition(
  seatNumber: json['seatNumber'] as String?,
  isAvailable: json['isAvailable'] as bool?,
);

Map<String, dynamic> _$SeatPositionToJson(SeatPosition instance) =>
    <String, dynamic>{
      'seatNumber': instance.seatNumber,
      'isAvailable': instance.isAvailable,
    };

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
  id: (json['id'] as num?)?.toInt(),
  busId: (json['busId'] as num?)?.toInt(),
  seatNumber: json['seatNumber'] as String?,
  seatType: json['seatType'] as String?,
  positionLabel: json['positionLabel'] as String?,
  status: json['status'] as String?,
  bookings: json['bookings'] as String?,
);

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
  'id': instance.id,
  'busId': instance.busId,
  'seatNumber': instance.seatNumber,
  'seatType': instance.seatType,
  'positionLabel': instance.positionLabel,
  'status': instance.status,
  'bookings': instance.bookings,
};
