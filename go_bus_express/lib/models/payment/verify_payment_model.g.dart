// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyPaymentModel _$VerifyPaymentModelFromJson(Map<String, dynamic> json) =>
    VerifyPaymentModel(
      completedExceptionally: json['completedExceptionally'] as bool?,
      numberOfDependents: (json['numberOfDependents'] as num?)?.toInt(),
      done: json['done'] as bool?,
      cancelled: json['cancelled'] as bool?,
    );

Map<String, dynamic> _$VerifyPaymentModelToJson(VerifyPaymentModel instance) =>
    <String, dynamic>{
      'completedExceptionally': instance.completedExceptionally,
      'numberOfDependents': instance.numberOfDependents,
      'done': instance.done,
      'cancelled': instance.cancelled,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
  message: json['message'] as String?,
  payment: json['payment'] == null
      ? null
      : Payment.fromJson(json['payment'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
  'message': instance.message,
  'payment': instance.payment,
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
);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
  'id': instance.id,
  'bookingId': instance.bookingId,
  'amount': instance.amount,
  'method': instance.method,
  'transactionId': instance.transactionId,
  'status': instance.status,
  'paidAt': instance.paidAt?.toIso8601String(),
};
