import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'update_profile_body.g.dart';

@JsonSerializable()
class UpdateProfileBody {
  final String email;
  final String fullName;
  final String phone;

  UpdateProfileBody(this.email, this.fullName, this.phone);

  factory UpdateProfileBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileBodyToJson(this);
}
