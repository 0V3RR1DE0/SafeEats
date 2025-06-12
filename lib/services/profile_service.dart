import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';

class ProfileService {
  static const String _profilesKey = 'profiles';
  final SharedPreferences _prefs;

  ProfileService(this._prefs);

  static Future<ProfileService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ProfileService(prefs);
  }

  Future<List<Profile>> getProfiles() async {
    final profilesJson = _prefs.getStringList(_profilesKey) ?? [];
    return profilesJson
        .map((json) => Profile.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveProfiles(List<Profile> profiles) async {
    final profilesJson =
        profiles.map((profile) => jsonEncode(profile.toJson())).toList();
    await _prefs.setStringList(_profilesKey, profilesJson);
  }

  Future<void> addProfile(Profile profile) async {
    final profiles = await getProfiles();
    profiles.add(profile);
    await saveProfiles(profiles);
  }

  Future<void> updateProfile(Profile profile) async {
    final profiles = await getProfiles();
    final index = profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      profiles[index] = profile;
      await saveProfiles(profiles);
    }
  }

  Future<void> deleteProfile(String profileId) async {
    final profiles = await getProfiles();
    profiles.removeWhere((p) => p.id == profileId);
    await saveProfiles(profiles);
  }

  Future<Profile?> getActiveProfile() async {
    final profiles = await getProfiles();
    try {
      return profiles.firstWhere((p) => p.isActive);
    } catch (_) {
      if (profiles.isNotEmpty) {
        // If no active profile, set the first one as active
        final firstProfile = profiles.first.copyWith(isActive: true);
        await updateProfile(firstProfile);
        return firstProfile;
      }
      return null;
    }
  }

  Future<void> setActiveProfile(String profileId) async {
    final profiles = await getProfiles();
    for (var profile in profiles) {
      profile.isActive = profile.id == profileId;
    }
    await saveProfiles(profiles);
  }

  Future<bool> checkProductRestrictions(String barcode) async {
    final activeProfile = await getActiveProfile();
    if (activeProfile == null) return false;

    // TODO: Implement product checking against active profile restrictions
    return false;
  }

  // This method is no longer needed as we're using localized strings
  // but kept for backward compatibility
  List<String> getCommonRestrictions() {
    return [
      // Allergens
      'Peanuts',
      'Tree Nuts',
      'Milk',
      'Eggs',
      'Fish',
      'Shellfish',
      'Soy',
      'Wheat',
      // Dietary
      'Vegetarian',
      'Vegan',
      'Gluten-Free',
      'Lactose-Free',
      // Religious
      'Halal',
      'Kosher',
      // Medical
      'Low Sodium',
      'Sugar-Free',
      'Low Fat',
    ];
  }

  // This method is no longer needed as we're using the category from the UI
  // but kept for backward compatibility
  RestrictionCategory getCategoryForRestriction(String restriction) {
    final allergens = [
      'peanuts',
      'tree nuts',
      'milk',
      'eggs',
      'fish',
      'shellfish',
      'soy',
      'wheat',
    ];

    final dietary = [
      'vegetarian',
      'vegan',
      'gluten-free',
      'lactose-free',
    ];

    final religious = [
      'halal',
      'kosher',
    ];

    final medical = [
      'low sodium',
      'sugar-free',
      'low fat',
    ];

    final lowerRestriction = restriction.toLowerCase();

    if (allergens.contains(lowerRestriction)) {
      return RestrictionCategory.allergen;
    } else if (dietary.contains(lowerRestriction)) {
      return RestrictionCategory.dietary;
    } else if (religious.contains(lowerRestriction)) {
      return RestrictionCategory.religious;
    } else if (medical.contains(lowerRestriction)) {
      return RestrictionCategory.medical;
    }

    return RestrictionCategory.dietary;
  }
}
