// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: (json['id'] as num?)?.toInt(),
  userName: json['userName'] as String?,
  fullName: json['fullName'] as String?,
  email: json['email'] as String?,
  image: json['image'] as String?,
  phone: json['phone'] as String?,
  googleId: json['googleId'] as String?,
  gender: json['gender'] as String?,
  createdAt: json['createdAt'] as String?,
  isEmployee: json['isEmployee'] as bool?,
  isWalletExist: json['isWalletExist'] as bool?,
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'fullName': instance.fullName,
      'email': instance.email,
      'image': instance.image,
      'phone': instance.phone,
      'googleId': instance.googleId,
      'gender': instance.gender,
      'createdAt': instance.createdAt,
      'isEmployee': instance.isEmployee,
      'isWalletExist': instance.isWalletExist,
    };
