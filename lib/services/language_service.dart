import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _localeKey = 'locale';
  static final LanguageService _instance = LanguageService._internal();

  // Stream controller for locale changes
  final _localeController = StreamController<Locale?>.broadcast();
  Stream<Locale?> get localeStream => _localeController.stream;

  factory LanguageService() {
    return _instance;
  }

  LanguageService._internal();

  Future<Locale?> getCurrentLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(_localeKey);

    if (localeString == null) {
      return null; // Use system locale
    }

    final parts = localeString.split('_');
    if (parts.length == 1) {
      return Locale(parts[0]);
    } else if (parts.length >= 2) {
      return Locale(parts[0], parts[1]);
    }

    return null;
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    String localeString;

    if (locale.countryCode != null) {
      localeString = '${locale.languageCode}_${locale.countryCode}';
    } else {
      localeString = locale.languageCode;
    }

    await prefs.setString(_localeKey, localeString);
    _localeController.add(locale);
  }

  Future<void> useSystemLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
    _localeController.add(null);
  }

  Future<List<Locale>> getSupportedLocales() async {
    // Only return locales that have actual translations
    return const [
      Locale('en'), // English
      Locale('fi'), // Finnish
    ];
  }

  Future<Map<Locale, String>> getLanguageMap() async {
    // Return a map of locales to their display names
    return {
      const Locale('en'): 'English',
      const Locale('fi'): 'Suomi',
    };
  }

  void dispose() {
    _localeController.close();
  }
}
