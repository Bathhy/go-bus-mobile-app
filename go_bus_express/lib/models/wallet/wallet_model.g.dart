// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => WalletModel(
  id: json['id'] as String?,
  userId: (json['userId'] as num?)?.toInt(),
  userName: json['userName'] as String?,
  fullName: json['fullName'] as String?,
  balance: (json['balance'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  status: json['status'] as String?,
  lastTransaction: json['lastTransaction'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  walletSessionToken: json['walletSessionToken'] as String?,
);

Map<String, dynamic> _$WalletModelToJson(WalletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'fullName': instance.fullName,
      'balance': instance.balance,
      'currency': instance.currency,
      'status': instance.status,
      'lastTransaction': instance.lastTransaction,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'walletSessionToken': instance.walletSessionToken,
    };
