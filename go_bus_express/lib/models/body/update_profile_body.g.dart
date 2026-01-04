// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileBody _$UpdateProfileBodyFromJson(Map<String, dynamic> json) =>
    UpdateProfileBody(
      json['email'] as String,
      json['fullName'] as String,
      json['phone'] as String,
    );

Map<String, dynamic> _$UpdateProfileBodyToJson(UpdateProfileBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'fullName': instance.fullName,
      'phone': instance.phone,
    };
