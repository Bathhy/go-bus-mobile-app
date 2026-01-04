import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';
import 'package:go_bus_express/view_models/controller/profile/profile_state.dart';
import 'package:shared_package/network/x_result.dart';

import '../../../core/storage/local_repository.dart';
import '../../../models/body/update_profile_body.dart';
import '../../../models/profile/profile_model.dart';
import '../../../resources/localizations/app_localization.dart';
import '../../../resources/routes/app_routes.dart';

class ProfileController extends BaseController<ProfileState> {
  final LocalRepository _localRepository;

  ProfileController(this._localRepository) : super(ProfileState());

  void loadCurrentLanguage() {
    final language = _localRepository.getLanguage() ?? 'en';
    updateState((state) => state.copyWith(currentLanguage: language));
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

  void refreshProfile() {
    loadCachedProfile();
    loadCurrentLanguage();
    log('Profile refreshed from cache');
  }

  Future<void> changeLanguage(String languageCode) async {
    await AppLocalization.saveLanguage(languageCode);
    Get.updateLocale(Locale(languageCode));
    updateState((state) => state.copyWith(currentLanguage: languageCode));
    log('Language changed to: $languageCode');
  }

  String getCurrentLanguage() {
    return state.currentLanguage;
  }

  void logout() {
    _localRepository.logout();
    Get.offAllNamed(AppRoutes.signIn);
  }
}
