import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final int? id;
  final String? userName;
  final String? fullName;
  final String? email;
  final String? image;
  final String? phone;
  final String? googleId;
  final String? gender;
  final String? createdAt;
  final bool? isEmployee;

  const ProfileModel({
    this.id,
    this.userName,
    this.fullName,
    this.email,
    this.image,
    this.phone,
    this.googleId,
    this.gender,
    this.createdAt,
    this.isEmployee,
  });

  ProfileModel copyWith({
    int? id,
    String? userName,
    String? fullName,
    String? email,
    String? phone,
    String? googleId,
    String? image,
    String? gender,
    String? createdAt,
    bool? isEmployee,
  }) => ProfileModel(
    id: id ?? this.id,
    userName: userName ?? this.userName,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    image: image ?? this.image,
    phone: phone ?? this.phone,
    googleId: googleId ?? this.googleId,
    gender: gender ?? this.gender,
    createdAt: createdAt ?? this.createdAt,
    isEmployee: isEmployee ?? this.isEmployee,
  );

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
