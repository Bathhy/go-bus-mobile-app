// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: (json['id'] as num?)?.toInt(),
  fullName: json['fullName'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  googleId: json['googleId'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'googleId': instance.googleId,
      'image': instance.image,
    };
