import 'package:shared_preferences/shared_preferences.dart';

/// Service for storing user preferences locally
class PreferencesStorage {
  PreferencesStorage(this._preferences);

  final SharedPreferences _preferences;

  // Keys
  static const String _rememberedEmailKey = 'remembered_email';
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _notificationsEnabledKey = 'notifications_enabled';

  // Remember Me
  Future<void> saveRememberedEmail(String email) async {
    await _preferences.setString(_rememberedEmailKey, email);
  }

  String? getRememberedEmail() {
    return _preferences.getString(_rememberedEmailKey);
  }

  Future<void> clearRememberedEmail() async {
    await _preferences.remove(_rememberedEmailKey);
  }

  // Theme
  Future<void> saveThemeMode(String mode) async {
    await _preferences.setString(_themeKey, mode);
  }

  String getThemeMode() {
    return _preferences.getString(_themeKey) ?? 'light';
  }

  // Language
  Future<void> saveLanguage(String language) async {
    await _preferences.setString(_languageKey, language);
  }

  String getLanguage() {
    return _preferences.getString(_languageKey) ?? 'th';
  }

  // Notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _preferences.setBool(_notificationsEnabledKey, enabled);
  }

  bool getNotificationsEnabled() {
    return _preferences.getBool(_notificationsEnabledKey) ?? true;
  }

  // Clear all preferences
  Future<void> clearAll() async {
    await _preferences.clear();
  }
}
