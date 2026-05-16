import 'package:json_annotation/json_annotation.dart';

part 'wallet_topup_khqr_model.g.dart';

@JsonSerializable()
class WalletTopUpKhqrModel {
  final WalletTopUpKhqrData? data;
  final WalletKhqrStatus? khqrstatus;

  const WalletTopUpKhqrModel({this.data, this.khqrstatus});

  factory WalletTopUpKhqrModel.fromJson(Map<String, dynamic> json) =>
      _$WalletTopUpKhqrModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTopUpKhqrModelToJson(this);
}

@JsonSerializable()
class WalletTopUpKhqrData {
  final String? qr;
  final String? md5;

  const WalletTopUpKhqrData({this.qr, this.md5});

  factory WalletTopUpKhqrData.fromJson(Map<String, dynamic> json) =>
      _$WalletTopUpKhqrDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTopUpKhqrDataToJson(this);
}

@JsonSerializable()
class WalletKhqrStatus {
  final int? code;
  final String? errorCode;
  final String? message;

  const WalletKhqrStatus({this.code, this.errorCode, this.message});

  factory WalletKhqrStatus.fromJson(Map<String, dynamic> json) =>
      _$WalletKhqrStatusFromJson(json);

  Map<String, dynamic> toJson() => _$WalletKhqrStatusToJson(this);
}
