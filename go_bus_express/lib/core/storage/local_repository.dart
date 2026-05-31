import 'package:go_bus_express/resources/localizations/app_localization.dart';

import 'base_share_preference.dart';

class LocalRepository with BaseSharePreference {
  Future<void> saveToken(String token) async {
    await storeValue(PreferencesKey.token, token);
    await storeValue(PreferencesKey.isLogin, true);
  }

  String? getToken() {
    return readString(PreferencesKey.token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await storeValue(PreferencesKey.refreshToken, refreshToken);
  }

  String? getRefreshToken() {
    return readString(PreferencesKey.refreshToken);
  }

  Future<void> removeToken() async {
    await removeValue(PreferencesKey.token);
    await removeValue(PreferencesKey.refreshToken);
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
    await AppLocalization.clearLanguage();
    await logoutBox();
  }

  // Wallet session (token + 30-min expiry)
  Future<void> saveWalletSession(String token) async {
    final expiresAt = DateTime.now()
        .add(const Duration(minutes: 30))
        .millisecondsSinceEpoch;
    await storeValue(PreferencesKey.walletSessionToken, token);
    await storeValue(PreferencesKey.walletSessionExpiresAt, expiresAt);
  }

  String? getWalletSessionToken() {
    return readString(PreferencesKey.walletSessionToken);
  }

  DateTime? getWalletSessionExpiresAt() {
    final ms = readInt(PreferencesKey.walletSessionExpiresAt);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  bool isWalletSessionValid() {
    final token = getWalletSessionToken();
    final expiresAt = getWalletSessionExpiresAt();
    if (token == null || expiresAt == null) return false;
    return DateTime.now().isBefore(expiresAt);
  }

  Future<void> clearWalletSession() async {
    await removeValue(PreferencesKey.walletSessionToken);
    await removeValue(PreferencesKey.walletSessionExpiresAt);
    await removeValue(PreferencesKey.walletHash);
  }

  // Wallet hash (needed to generate top-up KHQR; returned by /wallets/login)
  Future<void> saveWalletHash(String hash) async {
    await storeValue(PreferencesKey.walletHash, hash);
  }

  String? getWalletHash() {
    return readString(PreferencesKey.walletHash);
  }

  // Profile image URL
  Future<void> saveProfileImageUrl(String url) async {
    await storeValue(PreferencesKey.profileImageUrl, url);
  }

  String? getProfileImageUrl() {
    return readString(PreferencesKey.profileImageUrl);
  }

  Future<void> removeProfileImageUrl() async {
    await removeValue(PreferencesKey.profileImageUrl);
  }

  // MARK : Payment Method

  Future<void> saveMD5(String md5) async {
    await storeValue(PreferencesKey.md5, md5);
  }

  String? getMD5() {
    return readString(PreferencesKey.md5);
  }

  Future<void> removeMD5() async {
    await removeValue(PreferencesKey.md5);
  }
}
