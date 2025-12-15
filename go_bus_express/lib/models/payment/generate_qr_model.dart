import 'package:json_annotation/json_annotation.dart';

part 'generate_qr_model.g.dart';

@JsonSerializable()
class GenerateQrModel {
  final String? qr;
  final String? md5;

  GenerateQrModel({this.qr, this.md5});

  factory GenerateQrModel.fromJson(Map<String, dynamic> json) =>
      _$GenerateQrModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateQrModelToJson(this);
}
