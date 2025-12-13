import 'package:json_annotation/json_annotation.dart';
part 'auth_body.g.dart';

@JsonSerializable()
class LoginBody {
  final String email;
  final String password;
  

  LoginBody({
    required this.email,
    required this.password,
  });

  factory LoginBody.fromJson(Map<String, dynamic> json) =>
      _$LoginBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LoginBodyToJson(this);
}
@JsonSerializable()
class SignupBody {
  final String email;
  final String password;
  final String fullName;

  SignupBody({
    required this.email,
    required this.password,
    required this.fullName,
  });

  factory SignupBody.fromJson(Map<String, dynamic> json) =>
      _$SignupBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SignupBodyToJson(this);
}