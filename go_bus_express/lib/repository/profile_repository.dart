import 'package:go_bus_express/data/app_api/go_bus_api.dart';
import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:shared_package/network/x_result.dart';

abstract class ProfileRepository {
  Future<XResult<ProfileModel?>> fetchProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final GoBusApi api;

  ProfileRepositoryImpl(this.api);

  @override
  Future<XResult<ProfileModel?>> fetchProfile() {
    return xResultHandler(() async {
      final response = await api.fetchProfile();
      return response.profile;
    });
  }
}
