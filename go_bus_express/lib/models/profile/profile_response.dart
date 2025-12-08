import 'package:json_annotation/json_annotation.dart';
import 'profile_model.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  final ProfileModel profile;

  const ProfileResponse({required this.profile});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
