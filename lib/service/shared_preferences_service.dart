import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesService(this._sharedPreferences);

  static const String _keyTheme = 'theme';

  Future<void> setTheme(String theme) async {
    try {
      await _sharedPreferences.setString(_keyTheme, theme);
    } on Exception {
      throw Exception("Theme can't be set");
    }
  }

  String getTheme() {
    return _sharedPreferences.getString(_keyTheme) ?? 'light';
  }
}
