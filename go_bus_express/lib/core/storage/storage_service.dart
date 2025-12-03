import 'base_share_preference.dart';

class LocalRepository with BaseSharePreference {
  Future<void> saveToken(String token) async {
    await storeValue(PreferencesKey.token, token);
    await storeValue(PreferencesKey.isLogin, true);
  }

  String? getToken() {
    return readString(PreferencesKey.token);
  }

  Future<void> removeToken() async {
    await removeValue(PreferencesKey.token);
    await removeValue(PreferencesKey.isLogin);
  }

  // Login status
  bool isLoggedIn() {
    return readBool(PreferencesKey.isLogin) ?? false;
  }

  // Language
  Future<void> saveLanguage(String language) async {
    await storeValue(PreferencesKey.language, language);
  }

  String? getLanguage() {
    return readString(PreferencesKey.language);
  }
  // Logout
  Future<void> logout() async {
    await logoutBox();
  }
}
