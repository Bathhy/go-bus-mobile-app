import 'package:shared_preferences/shared_preferences.dart';

enum PreferencesKey { token, fcm, language, theme, locale, isLogin, profile }

mixin class BaseSharePreference {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> storeValue<T>(PreferencesKey key, T value) async {
    if (_prefs == null) await init();

    if (value is String) {
      await _prefs?.setString(key.name, value);
    } else if (value is int) {
      await _prefs?.setInt(key.name, value);
    } else if (value is double) {
      await _prefs?.setDouble(key.name, value);
    } else if (value is bool) {
      await _prefs?.setBool(key.name, value);
    } else if (value is List<String>) {
      await _prefs?.setStringList(key.name, value);
    }
  }

  Future<void> removeValue(PreferencesKey key) async {
    if (_prefs == null) await init();
    await _prefs?.remove(key.name);
  }

  T? readValue<T>(PreferencesKey key) {
    if (_prefs == null) return null;
    return _prefs?.get(key.name) as T?;
  }

  String? readString(PreferencesKey key) {
    if (_prefs == null) return null;
    return _prefs?.getString(key.name);
  }

  int? readInt(PreferencesKey key) {
    if (_prefs == null) return null;
    return _prefs?.getInt(key.name);
  }

  bool? readBool(PreferencesKey key) {
    if (_prefs == null) return null;
    return _prefs?.getBool(key.name);
  }

  double? readDouble(PreferencesKey key) {
    if (_prefs == null) return null;
    return _prefs?.getDouble(key.name);
  }

  List<String>? readStringList(PreferencesKey key) {
    if (_prefs == null) return null;
    return _prefs?.getStringList(key.name);
  }

  Future<void> logoutBox() async {
    await removeValue(PreferencesKey.isLogin);
    await removeValue(PreferencesKey.token);
    await removeValue(PreferencesKey.locale);
    await removeValue(PreferencesKey.isLogin);
  }

  Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs?.clear();
  }

  bool containsKey(PreferencesKey key) {
    if (_prefs == null) return false;
    return _prefs?.containsKey(key.name) ?? false;
  }
}
