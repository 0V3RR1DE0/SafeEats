// lib/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<List<String>> getRestrictions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('restrictions') ?? [];
  }

  Future<void> saveRestrictions(List<String> restrictions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('restrictions', restrictions);
  }
}