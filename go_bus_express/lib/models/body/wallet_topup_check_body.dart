import 'package:json_annotation/json_annotation.dart';

part 'wallet_topup_check_body.g.dart';

@JsonSerializable()
class WalletTopUpCheckBody {
  final String hash;

  const WalletTopUpCheckBody({required this.hash});

  factory WalletTopUpCheckBody.fromJson(Map<String, dynamic> json) =>
      _$WalletTopUpCheckBodyFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTopUpCheckBodyToJson(this);
}
