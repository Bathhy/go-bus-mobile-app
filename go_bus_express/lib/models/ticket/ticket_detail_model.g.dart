// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketDetailModel _$TicketDetailModelFromJson(Map<String, dynamic> json) =>
    TicketDetailModel(
      id: (json['id'] as num?)?.toInt(),
      bookingDetailResponse: json['bookingDetailResponse'] == null
          ? null
          : BookingDetailResponse.fromJson(
              json['bookingDetailResponse'] as Map<String, dynamic>,
            ),
      qrCode: json['qrCode'] as String?,
      issuedAt: json['issuedAt'] == null
          ? null
          : DateTime.parse(json['issuedAt'] as String),
    );

Map<String, dynamic> _$TicketDetailModelToJson(TicketDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingDetailResponse': instance.bookingDetailResponse,
      'qrCode': instance.qrCode,
      'issuedAt': instance.issuedAt?.toIso8601String(),
    };

BookingDetailResponse _$BookingDetailResponseFromJson(
  Map<String, dynamic> json,
) => BookingDetailResponse(
  id: (json['id'] as num?)?.toInt(),
  bookingStatus: json['bookingStatus'] as String?,
  paymentStatus: json['paymentStatus'] as String?,
  paymentMethod: json['paymentMethod'] as String?,
  totalAmount: (json['totalAmount'] as num?)?.toDouble(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  phoneNumber: json['phoneNumber'] as String?,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  schedule: json['schedule'] == null
      ? null
      : Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
  promo: json['promo'],
  seats: (json['seats'] as List<dynamic>?)
      ?.map((e) => Seat.fromJson(e as Map<String, dynamic>))
      .toList(),
  payment: json['payment'] == null
      ? null
      : Payment.fromJson(json['payment'] as Map<String, dynamic>),
  ticket: json['ticket'] == null
      ? null
      : Ticket.fromJson(json['ticket'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookingDetailResponseToJson(
  BookingDetailResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'bookingStatus': instance.bookingStatus,
  'paymentStatus': instance.paymentStatus,
  'paymentMethod': instance.paymentMethod,
  'totalAmount': instance.totalAmount,
  'createdAt': instance.createdAt?.toIso8601String(),
  'phoneNumber': instance.phoneNumber,
  'user': instance.user,
  'schedule': instance.schedule,
  'promo': instance.promo,
  'seats': instance.seats,
  'payment': instance.payment,
  'ticket': instance.ticket,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  fullName: json['fullName'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'email': instance.email,
  'phone': instance.phone,
};

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
  id: (json['id'] as num?)?.toInt(),
  busId: (json['busId'] as num?)?.toInt(),
  busNumber: json['busNumber'] as String?,
  busType: json['busType'] as String?,
  departureDateTime: json['departureDateTime'] == null
      ? null
      : DateTime.parse(json['departureDateTime'] as String),
  arrivalDateTime: json['arrivalDateTime'] == null
      ? null
      : DateTime.parse(json['arrivalDateTime'] as String),
  price: (json['price'] as num?)?.toDouble(),
  origin: json['origin'] as String?,
  destination: json['destination'] as String?,
);

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
  'id': instance.id,
  'busId': instance.busId,
  'busNumber': instance.busNumber,
  'busType': instance.busType,
  'departureDateTime': instance.departureDateTime?.toIso8601String(),
  'arrivalDateTime': instance.arrivalDateTime?.toIso8601String(),
  'price': instance.price,
  'origin': instance.origin,
  'destination': instance.destination,
};

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
  seatId: (json['seatId'] as num?)?.toInt(),
  seatNumber: json['seatNumber'] as String?,
  seatType: json['seatType'] as String?,
  passengerNumber: json['passengerNumber'] as String?,
);

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
  'seatId': instance.seatId,
  'seatNumber': instance.seatNumber,
  'seatType': instance.seatType,
  'passengerNumber': instance.passengerNumber,
};

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
  id: (json['id'] as num?)?.toInt(),
  bookingId: (json['bookingId'] as num?)?.toInt(),
  amount: (json['amount'] as num?)?.toDouble(),
  method: json['method'] as String?,
  transactionId: json['transactionId'] as String?,
  status: json['status'] as String?,
  paidAt: json['paidAt'] == null
      ? null
      : DateTime.parse(json['paidAt'] as String),
  walletTransactionId: json['walletTransactionId'] as String?,
);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
  'id': instance.id,
  'bookingId': instance.bookingId,
  'amount': instance.amount,
  'method': instance.method,
  'transactionId': instance.transactionId,
  'status': instance.status,
  'paidAt': instance.paidAt?.toIso8601String(),
  'walletTransactionId': instance.walletTransactionId,
};

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
  id: (json['id'] as num?)?.toInt(),
  bookingId: (json['bookingId'] as num?)?.toInt(),
  qrCode: json['qrCode'] as String?,
  issuedAt: json['issuedAt'] == null
      ? null
      : DateTime.parse(json['issuedAt'] as String),
);

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'bookingId': instance.bookingId,
  'qrCode': instance.qrCode,
  'issuedAt': instance.issuedAt?.toIso8601String(),
};
