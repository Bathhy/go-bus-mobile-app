// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_topup_khqr_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTopUpKhqrModel _$WalletTopUpKhqrModelFromJson(
  Map<String, dynamic> json,
) => WalletTopUpKhqrModel(
  data: json['data'] == null
      ? null
      : WalletTopUpKhqrData.fromJson(json['data'] as Map<String, dynamic>),
  khqrstatus: json['khqrstatus'] == null
      ? null
      : WalletKhqrStatus.fromJson(json['khqrstatus'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WalletTopUpKhqrModelToJson(
  WalletTopUpKhqrModel instance,
) => <String, dynamic>{
  'data': instance.data,
  'khqrstatus': instance.khqrstatus,
};

WalletTopUpKhqrData _$WalletTopUpKhqrDataFromJson(Map<String, dynamic> json) =>
    WalletTopUpKhqrData(qr: json['qr'] as String?, md5: json['md5'] as String?);

Map<String, dynamic> _$WalletTopUpKhqrDataToJson(
  WalletTopUpKhqrData instance,
) => <String, dynamic>{'qr': instance.qr, 'md5': instance.md5};

WalletKhqrStatus _$WalletKhqrStatusFromJson(Map<String, dynamic> json) =>
    WalletKhqrStatus(
      code: (json['code'] as num?)?.toInt(),
      errorCode: json['errorCode'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$WalletKhqrStatusToJson(WalletKhqrStatus instance) =>
    <String, dynamic>{
      'code': instance.code,
      'errorCode': instance.errorCode,
      'message': instance.message,
    };
