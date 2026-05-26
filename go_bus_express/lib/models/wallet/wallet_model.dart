import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable()
class WalletModel {
  final String? id;
  final int? userId;
  final String? userName;
  final String? fullName;
  final double? balance;
  final String? currency;
  final String? status;
  final String? lastTransaction;
  final String? createdAt;
  final String? updatedAt;
  final String? walletSessionToken;
  final String? hash;

  const WalletModel({
    this.id,
    this.userId,
    this.userName,
    this.fullName,
    this.balance,
    this.currency,
    this.status,
    this.lastTransaction,
    this.createdAt,
    this.updatedAt,
    this.walletSessionToken,
    this.hash,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletModelToJson(this);

  WalletModel copyWith({
    String? id,
    int? userId,
    String? userName,
    String? fullName,
    double? balance,
    String? currency,
    String? status,
    String? lastTransaction,
    String? createdAt,
    String? updatedAt,
    String? walletSessionToken,
    String? hash,
  }) {
    return WalletModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      lastTransaction: lastTransaction ?? this.lastTransaction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      walletSessionToken: walletSessionToken ?? this.walletSessionToken,
      hash: hash ?? this.hash,
    );
  }
}
