import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/profile/profile_state.dart';

import '../../../core/storage/local_repository.dart';
import '../../../models/profile/profile_model.dart';
import '../../../resources/localizations/app_localization.dart';

class ProfileController extends BaseController<ProfileState> {
  final LocalRepository _localRepository;

  ProfileController(this._localRepository) : super(ProfileState());

  @override
  void onInit() {
    loadCachedProfile();
    loadCurrentLanguage();
    super.onInit();
  }

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

  Future<void> changeLanguage(String languageCode) async {
    await AppLocalization.saveLanguage(languageCode);
    Get.updateLocale(Locale(languageCode));
    updateState((state) => state.copyWith(currentLanguage: languageCode));
    log('Language changed to: $languageCode');
  }

  String getCurrentLanguage() {
    return state.currentLanguage;
  }

  Future<void> clearLanguage() async {
    await AppLocalization.clearLanguage();
    log('Language cleared, reverting to default');
  }
}
