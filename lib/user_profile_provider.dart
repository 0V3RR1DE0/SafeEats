import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile.dart';
import 'dart:convert';

class UserProfileProvider with ChangeNotifier {
  List<UserProfile> _profiles = [];
  UserProfile? _activeProfile;

  List<UserProfile> get profiles => _profiles;
  UserProfile? get activeProfile => _activeProfile;

  // Save profiles to shared preferences
  Future<void> saveProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> profilesJson = _profiles.map((profile) => json.encode(profile.toJson())).toList();
    prefs.setStringList('profiles', profilesJson);
  }

  // Load profiles from shared preferences
  Future<void> loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? profilesJson = prefs.getStringList('profiles');
    if (profilesJson != null) {
      _profiles = profilesJson.map((jsonString) => UserProfile.fromJson(json.decode(jsonString))).toList();
      notifyListeners();
    }
  }

  void addProfile(UserProfile profile) {
    _profiles.add(profile);
    notifyListeners();
    saveProfiles();
  }

  void setActiveProfile(UserProfile profile) {
    _activeProfile = profile;
    notifyListeners();
  }
}
