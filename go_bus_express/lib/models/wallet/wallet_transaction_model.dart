import 'package:json_annotation/json_annotation.dart';

part 'wallet_transaction_model.g.dart';

@JsonSerializable()
class WalletTransactionPage {
  final List<WalletTransactionModel>? content;
  final int? totalElements;
  final int? totalPages;
  final int? size;
  final int? number;
  final bool? last;
  final bool? first;

  const WalletTransactionPage({
    this.content,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.last,
    this.first,
  });

  factory WalletTransactionPage.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionPageFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTransactionPageToJson(this);
}

@JsonSerializable()
class WalletTransactionModel {
  final int? id;
  final String? walletId;
  final double? amount;
  final String? type;
  final String? status;
  final String? referenceId;
  final String? description;
  final double? balanceBefore;
  final double? balanceAfter;
  final String? metadata;
  final String? createdAt;
  final String? completedAt;

  const WalletTransactionModel({
    this.id,
    this.walletId,
    this.amount,
    this.type,
    this.status,
    this.referenceId,
    this.description,
    this.balanceBefore,
    this.balanceAfter,
    this.metadata,
    this.createdAt,
    this.completedAt,
  });

  bool get isCredit => type == 'TOP_UP' || type == 'REFUND' || type == 'DEPOSIT';

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTransactionModelToJson(this);
}
