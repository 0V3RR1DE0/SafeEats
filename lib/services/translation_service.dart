// lib/services/translation_service.dart
import 'package:translator/translator.dart';

class TranslationService {
  static final GoogleTranslator _translator = GoogleTranslator();

  static Future<String> translate(String text, String sourceLang, String targetLang) async {
    try {
      var translation = await _translator.translate(text, from: sourceLang, to: targetLang);
      return translation.text;
    } catch (e) {
      print('Translation error: $e');
      return text; // Return original text if translation fails
    }
  }
}