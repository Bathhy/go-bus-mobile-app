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

  Future<void> removeLanguage() async {
    await removeValue(PreferencesKey.language);
  }

  // Profile
  Future<void> saveProfile(String profileJson) async {
    await storeValue(PreferencesKey.profile, profileJson);
  }

  String? getProfile() {
    return readString(PreferencesKey.profile);
  }

  Future<void> removeProfile() async {
    await removeValue(PreferencesKey.profile);
  }

  // Routes
  Future<void> saveRoutes(String routesJson) async {
    await storeValue(PreferencesKey.routes, routesJson);
  }

  String? getRoutes() {
    return readString(PreferencesKey.routes);
  }

  Future<void> removeRoutes() async {
    await removeValue(PreferencesKey.routes);
  }

  // Logout
  Future<void> logout() async {
    await logoutBox();
  }

  // MARK : Payment Method

  Future<void> saveMD5(String md5) async {
    await storeValue(PreferencesKey.md5, md5);
  }

  String? getMD5() {
    return readString(PreferencesKey.md5);
  }
}
