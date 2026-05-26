import 'package:json_annotation/json_annotation.dart';

part 'wallet_pay_body.g.dart';

@JsonSerializable()
class WalletPayBody {
  final String? description;

  const WalletPayBody({this.description});

  factory WalletPayBody.fromJson(Map<String, dynamic> json) =>
      _$WalletPayBodyFromJson(json);

  Map<String, dynamic> toJson() => _$WalletPayBodyToJson(this);
}
