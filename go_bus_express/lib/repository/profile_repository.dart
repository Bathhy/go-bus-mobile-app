import 'dart:io';

import 'package:dio/dio.dart';
import 'package:go_bus_express/data/app_api/go_bus_api.dart';
import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:shared_package/network/x_result.dart';

import '../models/body/update_profile_body.dart';
import '../models/profile/profile_image_url_model.dart';

abstract class ProfileRepository {
  Future<XResult<ProfileModel?>> fetchProfile();

  Future<XResult<ProfileModel?>> updateProfile(UpdateProfileBody body);

  Future<XResult<ProfileModel?>> uploadProfileImage(File imageFile);

  Future<XResult<ProfileImageUrlModel?>> fetchProfileImageUrl();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final GoBusApi api;

  ProfileRepositoryImpl(this.api);

  @override
  Future<XResult<ProfileModel?>> fetchProfile() {
    return xResultHandler(() async {
      final response = await api.fetchProfile();
      return response.data;
    });
  }

  @override
  Future<XResult<ProfileModel?>> updateProfile(UpdateProfileBody body) {
    return xResultHandler(() async {
      final response = await api.updateProfile(body);
      return response.data;
    });
  }

  @override
  Future<XResult<ProfileModel?>> uploadProfileImage(File imageFile) {
    return xResultHandler(() async {
      final file = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
      final response = await api.uploadProfileImage(file: file);
      return response.data;
    });
  }

  @override
  Future<XResult<ProfileImageUrlModel?>> fetchProfileImageUrl() {
    return xResultHandler(() async {
      final response = await api.fetchProfileImageUrl();
      return response.data;
    });
  }
}
