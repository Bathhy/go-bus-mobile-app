import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/storage/local_repository.dart';
import 'app_en_localize.dart';
import 'app_km_localize.dart';

class AppLocalization extends Translations {
  static final _localRepo = LocalRepository();

  static Future<void> saveLanguage(String languageCode) async {
    await _localRepo.saveLanguage(languageCode);
    log("Language saved: $languageCode");
    Get.updateLocale(Locale(languageCode));
  }

  static Future<void> getLanguage() async {
    String languageCode = _localRepo.getLanguage() ?? 'en';
    log("Language loaded: $languageCode");
    Get.updateLocale(Locale(languageCode));
  }

  static Locale getInitialLocale() {
    String languageCode = _localRepo.getLanguage() ?? 'en';
    log("Initial locale: $languageCode");
    return Locale(languageCode);
  }

  static Future<void> clearLanguage() async {
    await _localRepo.removeLanguage();
    log("Language cleared");
  }

  @override
  Map<String, Map<String, String>> get keys => {
    'en': en,
    'km': km,
  };
}
