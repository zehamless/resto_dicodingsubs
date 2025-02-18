import 'package:flutter/material.dart';
import 'package:resto_dicodingsubs/service/shared_preferences_service.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferencesService _prefsService;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider(this._prefsService) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _prefsService.setTheme(_themeMode == ThemeMode.light ? 'light' : 'dark');
    notifyListeners();
  }

  void _loadTheme() {
    _themeMode =
        _prefsService.getTheme() == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
