import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    try {
      // Get list of available .arb files from assets
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap =
          json.decode(manifestContent) as Map<String, dynamic>;

      final List<Locale> supportedLocales = [];

      // Look for .arb files in the assets
      for (String key in manifestMap.keys) {
        if (key.startsWith('lib/l10n/app_') && key.endsWith('.arb')) {
          // Extract language code from filename like "lib/l10n/app_en.arb"
          final filename = key.split('/').last;
          final languageCode = filename.substring(
              4, filename.length - 4); // Remove "app_" and ".arb"

          if (languageCode.isNotEmpty) {
            supportedLocales.add(Locale(languageCode));
          }
        }
      }

      // Fallback to hardcoded list if dynamic detection fails
      if (supportedLocales.isEmpty) {
        return const [
          Locale('en'), // English
          Locale('fi'), // Finnish
        ];
      }

      return supportedLocales;
    } catch (e) {
      // Fallback to hardcoded list if there's an error
      return const [
        Locale('en'), // English
        Locale('fi'), // Finnish
      ];
    }
  }

  Future<Map<Locale, String>> getLanguageMap() async {
    final supportedLocales = await getSupportedLocales();
    final Map<Locale, String> languageMap = {};

    for (final locale in supportedLocales) {
      languageMap[locale] = getLanguageDisplayName(locale);
    }

    return languageMap;
  }

  String getLanguageDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fi':
        return 'Suomi';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      case 'ar':
        return 'العربية';
      case 'hi':
        return 'हिन्दी';
      case 'tr':
        return 'Türkçe';
      case 'pl':
        return 'Polski';
      case 'nl':
        return 'Nederlands';
      case 'sv':
        return 'Svenska';
      case 'da':
        return 'Dansk';
      case 'no':
        return 'Norsk';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  void dispose() {
    _localeController.close();
  }
}
