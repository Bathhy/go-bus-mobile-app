// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_topup_khqr_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTopUpKhqrBody _$WalletTopUpKhqrBodyFromJson(Map<String, dynamic> json) =>
    WalletTopUpKhqrBody(
      amount: (json['amount'] as num).toDouble(),
      hash: json['hash'] as String,
    );

Map<String, dynamic> _$WalletTopUpKhqrBodyToJson(
  WalletTopUpKhqrBody instance,
) => <String, dynamic>{'amount': instance.amount, 'hash': instance.hash};
