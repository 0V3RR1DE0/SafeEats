import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeModeKey = 'theme_mode';
  static ThemeService? _instance;

  ThemeService._();

  static ThemeService get instance {
    _instance ??= ThemeService._();
    return _instance!;
  }

  ThemeMode _themeMode = ThemeMode.system;
  final List<VoidCallback> _listeners = [];

  ThemeMode get themeMode => _themeMode;

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);

    if (themeModeString != null) {
      switch (themeModeString) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
        default:
          _themeMode = ThemeMode.system;
          break;
      }
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;

    _themeMode = themeMode;

    final prefs = await SharedPreferences.getInstance();
    String themeModeString;

    switch (themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }

    await prefs.setString(_themeModeKey, themeModeString);
    _notifyListeners();
  }

  String getThemeModeDisplayName(
    ThemeMode mode, {
    required String lightText,
    required String darkText,
    required String systemText,
  }) {
    switch (mode) {
      case ThemeMode.light:
        return lightText;
      case ThemeMode.dark:
        return darkText;
      case ThemeMode.system:
        return systemText;
    }
  }
}
