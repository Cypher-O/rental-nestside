import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _kIsFirstLaunch = 'is_first_launch';
  static const _kThemeMode = 'theme_mode';

  bool isFirstLaunch() => _prefs.getBool(_kIsFirstLaunch) ?? true;

  Future<void> setFirstLaunch(bool value) =>
      _prefs.setBool(_kIsFirstLaunch, value);

  String getThemeMode() => _prefs.getString(_kThemeMode) ?? 'system';

  Future<void> setThemeMode(String mode) =>
      _prefs.setString(_kThemeMode, mode);
}
