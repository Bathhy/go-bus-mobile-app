import 'package:json_annotation/json_annotation.dart';

part 'wallet_topup_khqr_body.g.dart';

@JsonSerializable()
class WalletTopUpKhqrBody {
  final double amount;
  final String hash;

  const WalletTopUpKhqrBody({
    required this.amount,
    required this.hash,
  });

  factory WalletTopUpKhqrBody.fromJson(Map<String, dynamic> json) =>
      _$WalletTopUpKhqrBodyFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTopUpKhqrBodyToJson(this);
}
