// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundPage _$RefundPageFromJson(Map<String, dynamic> json) => RefundPage(
  content: (json['content'] as List<dynamic>?)
      ?.map((e) => RefundModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalElements: (json['totalElements'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  last: json['last'] as bool?,
  first: json['first'] as bool?,
);

Map<String, dynamic> _$RefundPageToJson(RefundPage instance) =>
    <String, dynamic>{
      'content': instance.content,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
      'first': instance.first,
    };

RefundModel _$RefundModelFromJson(Map<String, dynamic> json) => RefundModel(
  id: (json['id'] as num?)?.toInt(),
  bookingId: (json['bookingId'] as num?)?.toInt(),
  amount: (json['amount'] as num?)?.toDouble(),
  reason: json['reason'] as String?,
  status: json['status'] as String?,
  adminNote: json['adminNote'] as String?,
  processedBy: (json['processedBy'] as num?)?.toInt(),
  processedAt: json['processedAt'] == null
      ? null
      : DateTime.parse(json['processedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  booking: json['booking'] == null
      ? null
      : RefundBooking.fromJson(json['booking'] as Map<String, dynamic>),
  user: json['user'] == null
      ? null
      : RefundUser.fromJson(json['user'] as Map<String, dynamic>),
  schedule: json['schedule'] == null
      ? null
      : RefundSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
  route: json['route'] == null
      ? null
      : RefundRoute.fromJson(json['route'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RefundModelToJson(RefundModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'amount': instance.amount,
      'reason': instance.reason,
      'status': instance.status,
      'adminNote': instance.adminNote,
      'processedBy': instance.processedBy,
      'processedAt': instance.processedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'booking': instance.booking,
      'user': instance.user,
      'schedule': instance.schedule,
      'route': instance.route,
    };

RefundBooking _$RefundBookingFromJson(Map<String, dynamic> json) =>
    RefundBooking(
      id: (json['id'] as num?)?.toInt(),
      bookingStatus: json['bookingStatus'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      seats: (json['seats'] as List<dynamic>?)
          ?.map((e) => RefundSeat.fromJson(e as Map<String, dynamic>))
          .toList(),
      promo: json['promo'],
    );

Map<String, dynamic> _$RefundBookingToJson(RefundBooking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingStatus': instance.bookingStatus,
      'paymentStatus': instance.paymentStatus,
      'paymentMethod': instance.paymentMethod,
      'totalAmount': instance.totalAmount,
      'phoneNumber': instance.phoneNumber,
      'createdAt': instance.createdAt?.toIso8601String(),
      'seats': instance.seats,
      'promo': instance.promo,
    };

RefundSeat _$RefundSeatFromJson(Map<String, dynamic> json) => RefundSeat(
  seatId: (json['seatId'] as num?)?.toInt(),
  passengerNumber: json['passengerNumber'] as String?,
);

Map<String, dynamic> _$RefundSeatToJson(RefundSeat instance) =>
    <String, dynamic>{
      'seatId': instance.seatId,
      'passengerNumber': instance.passengerNumber,
    };

RefundUser _$RefundUserFromJson(Map<String, dynamic> json) => RefundUser(
  id: (json['id'] as num?)?.toInt(),
  userName: json['userName'] as String?,
  fullName: json['fullName'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$RefundUserToJson(RefundUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
    };

RefundSchedule _$RefundScheduleFromJson(Map<String, dynamic> json) =>
    RefundSchedule(
      id: (json['id'] as num?)?.toInt(),
      departureDateTime: json['departureDateTime'] == null
          ? null
          : DateTime.parse(json['departureDateTime'] as String),
      arrivalDateTime: json['arrivalDateTime'] == null
          ? null
          : DateTime.parse(json['arrivalDateTime'] as String),
      price: (json['price'] as num?)?.toDouble(),
      availableSeats: (json['availableSeats'] as num?)?.toInt(),
      bus: json['bus'] == null
          ? null
          : RefundBus.fromJson(json['bus'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RefundScheduleToJson(RefundSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'departureDateTime': instance.departureDateTime?.toIso8601String(),
      'arrivalDateTime': instance.arrivalDateTime?.toIso8601String(),
      'price': instance.price,
      'availableSeats': instance.availableSeats,
      'bus': instance.bus,
    };

RefundBus _$RefundBusFromJson(Map<String, dynamic> json) => RefundBus(
  id: (json['id'] as num?)?.toInt(),
  busNumber: json['busNumber'] as String?,
  busType: json['busType'] as String?,
  totalSeats: (json['totalSeats'] as num?)?.toInt(),
);

Map<String, dynamic> _$RefundBusToJson(RefundBus instance) => <String, dynamic>{
  'id': instance.id,
  'busNumber': instance.busNumber,
  'busType': instance.busType,
  'totalSeats': instance.totalSeats,
};

RefundRoute _$RefundRouteFromJson(Map<String, dynamic> json) => RefundRoute(
  id: (json['id'] as num?)?.toInt(),
  routeName: json['routeName'] as String?,
  origin: json['origin'] as String?,
  destination: json['destination'] as String?,
  distance: (json['distance'] as num?)?.toDouble(),
  estimatedDuration: (json['estimatedDuration'] as num?)?.toInt(),
);

Map<String, dynamic> _$RefundRouteToJson(RefundRoute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routeName': instance.routeName,
      'origin': instance.origin,
      'destination': instance.destination,
      'distance': instance.distance,
      'estimatedDuration': instance.estimatedDuration,
    };
