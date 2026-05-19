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
  final String userName;
  final bool isEmployee;
  final String phone;

  SignupBody({
    required this.email,
    required this.password,
    required this.fullName,
    required this.userName,
    required this.phone,
    this.isEmployee = false,
  });

  factory SignupBody.fromJson(Map<String, dynamic> json) =>
      _$SignupBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SignupBodyToJson(this);
}