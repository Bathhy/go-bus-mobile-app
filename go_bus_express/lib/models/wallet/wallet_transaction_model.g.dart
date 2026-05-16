// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTransactionPage _$WalletTransactionPageFromJson(
  Map<String, dynamic> json,
) => WalletTransactionPage(
  content: (json['content'] as List<dynamic>?)
      ?.map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalElements: (json['totalElements'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  number: (json['number'] as num?)?.toInt(),
  last: json['last'] as bool?,
  first: json['first'] as bool?,
);

Map<String, dynamic> _$WalletTransactionPageToJson(
  WalletTransactionPage instance,
) => <String, dynamic>{
  'content': instance.content,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'size': instance.size,
  'number': instance.number,
  'last': instance.last,
  'first': instance.first,
};

WalletTransactionModel _$WalletTransactionModelFromJson(
  Map<String, dynamic> json,
) => WalletTransactionModel(
  id: (json['id'] as num?)?.toInt(),
  walletId: json['walletId'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  type: json['type'] as String?,
  status: json['status'] as String?,
  referenceId: json['referenceId'] as String?,
  description: json['description'] as String?,
  balanceBefore: (json['balanceBefore'] as num?)?.toDouble(),
  balanceAfter: (json['balanceAfter'] as num?)?.toDouble(),
  metadata: json['metadata'] as String?,
  createdAt: json['createdAt'] as String?,
  completedAt: json['completedAt'] as String?,
);

Map<String, dynamic> _$WalletTransactionModelToJson(
  WalletTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'walletId': instance.walletId,
  'amount': instance.amount,
  'type': instance.type,
  'status': instance.status,
  'referenceId': instance.referenceId,
  'description': instance.description,
  'balanceBefore': instance.balanceBefore,
  'balanceAfter': instance.balanceAfter,
  'metadata': instance.metadata,
  'createdAt': instance.createdAt,
  'completedAt': instance.completedAt,
};
