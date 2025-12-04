import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final int? id;
  final String? fullName;
  final String? email;
  final String? image;

  const ProfileModel({
    this.id,
    this.fullName,
    this.email,
    this.image,
  });

  ProfileModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? googleId,
    String? image,
  }) => ProfileModel(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    image: image ?? this.image,
  );

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
