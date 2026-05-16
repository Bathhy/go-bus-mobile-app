import 'dart:convert';

import 'package:go_bus_express/models/home/all_route_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'seat_layout_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SeatLayoutModel {
  final int? id;
  final String? busNumber;
  final String? plate;
  final String? model;
  final String? busType;
  final String? status;
  final int? totalSeats;
  final AllRouteModel? route;
  final LayoutInfo? layout;
  @JsonKey(name: 'seats')
  final List<Seat>? seat;

  const SeatLayoutModel({
    this.id,
    this.busNumber,
    this.plate,
    this.model,
    this.busType,
    this.status,
    this.totalSeats,
    this.route,
    this.layout,
    this.seat,
  });

  // Helper getter for backward compatibility
  BusLayoutModel? get busLayout => BusLayoutModel(
    id: id,
    busNumber: busNumber,
    layout: layout,
  );

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
  final String? name;
  final String? description;
  final DateTime? createdAt;
  @JsonKey(fromJson: _layoutFromJson)
  final LayoutData? layout;

  LayoutInfo({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.layout,
  });

  static LayoutData? _layoutFromJson(dynamic json) {
    if (json == null) return null;
    
    if (json is String) {
      // Parse JSON string
      try {
        final dynamic parsed = const JsonDecoder().convert(json);
        
        // Handle array format: [{"row": 1, "seats": ["A1", "A2"]}, ...]
        if (parsed is List) {
          final seats = parsed.map((rowData) {
            final seatsList = rowData['seats'] as List?;
            if (seatsList == null) return <SeatPosition>[];
            
            return seatsList.map((seatNum) {
              return SeatPosition(
                seatNumber: seatNum?.toString(),
                isAvailable: true,
              );
            }).toList();
          }).toList();
          
          return LayoutData(seats: seats);
        }
        
        // Handle object format
        if (parsed is Map) {
          return LayoutData.fromJson(Map<String, dynamic>.from(parsed));
        }
      } catch (e) {
        return null;
      }
    } else if (json is List) {
      // Handle direct array format
      final seats = json.map((rowData) {
        final seatsList = rowData['seats'] as List?;
        if (seatsList == null) return <SeatPosition>[];
        
        return seatsList.map((seatNum) {
          return SeatPosition(
            seatNumber: seatNum?.toString(),
            isAvailable: true,
          );
        }).toList();
      }).toList();
      
      return LayoutData(seats: seats);
    } else if (json is Map) {
      return LayoutData.fromJson(Map<String, dynamic>.from(json));
    }
    return null;
  }

  factory LayoutInfo.fromJson(Map<String, dynamic> json) =>
      _$LayoutInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LayoutInfoToJson(this);
}

@JsonSerializable()
class LayoutData {
  final int? rows;
  final int? columns;
  final int? totalSeats;
  final String? aisleColumns;
  final int? driverColumn;
  final List<List<SeatPosition>>? seats;

  LayoutData({
    this.rows,
    this.columns,
    this.totalSeats,
    this.aisleColumns,
    this.driverColumn,
    this.seats,
  });

  factory LayoutData.fromJson(Map<String, dynamic> json) {
    // Handle array format from API: [{"row": 1, "seats": ["A1", "A2"]}, ...]
    if (json.containsKey('seats') && json['seats'] is List) {
      return _$LayoutDataFromJson(json);
    }
    
    // Handle direct array format (legacy)
    return LayoutData(
      rows: json['rows'] as int?,
      columns: json['columns'] as int?,
      totalSeats: json['totalSeats'] as int?,
      aisleColumns: json['aisleColumns'] as String?,
      driverColumn: json['driverColumn'] as int?,
      seats: json['seats'] != null
          ? (json['seats'] as List)
              .map((row) => (row as List)
                  .map((seat) {
                    // Handle null seats in the layout
                    if (seat == null) {
                      return SeatPosition(seatNumber: null, isAvailable: false);
                    }
                    return SeatPosition.fromJson(
                        seat is Map ? Map<String, dynamic>.from(seat) : {'seatNumber': seat});
                  })
                  .toList())
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$LayoutDataToJson(this);
}

@JsonSerializable()
class SeatPosition {
  final String? seatNumber;
  final bool? isAvailable;

  SeatPosition({
    this.seatNumber,
    this.isAvailable,
  });

  factory SeatPosition.fromJson(Map<String, dynamic> json) =>
      _$SeatPositionFromJson(json);

  Map<String, dynamic> toJson() => _$SeatPositionToJson(this);
}

@JsonSerializable()
class Seat {
  final int? id;
  final int? busId;
  final String? seatNumber;
  final String? seatType;
  final String? positionLabel;
  final String? status;
  final String? bookings;

  Seat({
    this.id,
    this.busId,
    this.seatNumber,
    this.seatType,
    this.positionLabel,
    this.status,
    this.bookings,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);
}
