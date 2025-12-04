import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/profile/profile_state.dart';

import '../../../core/storage/local_repository.dart';
import '../../../models/profile/profile_model.dart';

class ProfileController extends BaseController<ProfileState> {
  final LocalRepository _localRepository;

  ProfileController(this._localRepository) : super(ProfileState());

  @override
  void onInit() {
    loadCachedProfile();
    super.onInit();
  }

  void loadCachedProfile() {
    final cachedProfile = _localRepository.getProfile();
    if (cachedProfile != null) {
      try {
        final profileJson = jsonDecode(cachedProfile) as Map<String, dynamic>;
        final profile = ProfileModel.fromJson(profileJson);
        updateState((state) => state.copyWith(profileModel: profile));
        log('Loaded cached profile: ${profile.fullName}');
      } catch (e) {
        log('Failed to load cached profile: $e');
      }
    }
  }
}
