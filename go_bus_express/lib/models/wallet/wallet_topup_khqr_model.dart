import 'package:json_annotation/json_annotation.dart';

part 'wallet_topup_khqr_model.g.dart';

/// Matches the API response `data` shape:
/// { "qr": "...", "md5": "..." }
@JsonSerializable()
class WalletTopUpKhqrModel {
  final String? qr;
  final String? md5;

  const WalletTopUpKhqrModel({this.qr, this.md5});

  factory WalletTopUpKhqrModel.fromJson(Map<String, dynamic> json) =>
      _$WalletTopUpKhqrModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTopUpKhqrModelToJson(this);
}
