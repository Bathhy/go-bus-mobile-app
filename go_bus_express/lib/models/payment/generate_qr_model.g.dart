// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_qr_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateQrModel _$GenerateQrModelFromJson(Map<String, dynamic> json) =>
    GenerateQrModel(
      data: json['data'] == null
          ? null
          : DataData.fromJson(json['data'] as Map<String, dynamic>),
      khqrstatus: json['khqrstatus'] == null
          ? null
          : Khqrstatus.fromJson(json['khqrstatus'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GenerateQrModelToJson(GenerateQrModel instance) =>
    <String, dynamic>{'data': instance.data, 'khqrstatus': instance.khqrstatus};

DataData _$DataDataFromJson(Map<String, dynamic> json) =>
    DataData(qr: json['qr'] as String?, md5: json['md5'] as String?);

Map<String, dynamic> _$DataDataToJson(DataData instance) => <String, dynamic>{
  'qr': instance.qr,
  'md5': instance.md5,
};

Khqrstatus _$KhqrstatusFromJson(Map<String, dynamic> json) => Khqrstatus(
  code: (json['code'] as num?)?.toInt(),
  errorCode: json['errorCode'],
  message: json['message'],
);

Map<String, dynamic> _$KhqrstatusToJson(Khqrstatus instance) =>
    <String, dynamic>{
      'code': instance.code,
      'errorCode': instance.errorCode,
      'message': instance.message,
    };
