import 'package:shared_preferences/shared_preferences.dart';

abstract interface class PreferencesStore {
  String? getString(String key);
  Future<void> setString(String key, String value);
}

final class SharedPreferencesStore implements PreferencesStore {
  const SharedPreferencesStore(this._preferences);
  final SharedPreferences _preferences;

  @override
  String? getString(String key) => _preferences.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }
}
