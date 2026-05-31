import 'package:json_annotation/json_annotation.dart';

part 'profile_image_url_model.g.dart';

@JsonSerializable()
class ProfileImageUrlModel {
  final String? imageUrl;
  final String? objectName;

  const ProfileImageUrlModel({this.imageUrl, this.objectName});

  factory ProfileImageUrlModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageUrlModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileImageUrlModelToJson(this);
}
