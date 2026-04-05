import 'package:json_annotation/json_annotation.dart';

part 'generate_qr_model.g.dart';

// @JsonSerializable()
// class GenerateQrModel {
//   final String? qr;
//   final String? md5;

//   GenerateQrModel({this.qr, this.md5});

//   factory GenerateQrModel.fromJson(Map<String, dynamic> json) =>
//       _$GenerateQrModelFromJson(json);

//   Map<String, dynamic> toJson() => _$GenerateQrModelToJson(this);
// }
// part 'generate_qr_model.g.dart';

@JsonSerializable()
class GenerateQrModel {
  final DataData? data;
  final Khqrstatus? khqrstatus;

  GenerateQrModel({this.data, this.khqrstatus});

  factory GenerateQrModel.fromJson(Map<String, dynamic> json) =>
      _$GenerateQrModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateQrModelToJson(this);
}

@JsonSerializable()
class DataData {
  final String? qr;
  final String? md5;

  DataData({this.qr, this.md5});

  factory DataData.fromJson(Map<String, dynamic> json) =>
      _$DataDataFromJson(json);

  Map<String, dynamic> toJson() => _$DataDataToJson(this);
}

@JsonSerializable()
class Khqrstatus {
  final int? code;
  final dynamic errorCode;
  final dynamic message;

  Khqrstatus({this.code, this.errorCode, this.message});

  factory Khqrstatus.fromJson(Map<String, dynamic> json) =>
      _$KhqrstatusFromJson(json);

  Map<String, dynamic> toJson() => _$KhqrstatusToJson(this);
}
