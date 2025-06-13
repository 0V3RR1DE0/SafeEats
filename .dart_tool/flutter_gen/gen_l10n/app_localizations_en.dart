// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SafeEats';

  @override
  String get scan => 'Scan';

  @override
  String get profiles => 'Profiles';

  @override
  String get settings => 'Settings';

  @override
  String get noProfilesYet => 'No profiles yet';

  @override
  String get addProfileToStart => 'Add a profile to get started';

  @override
  String get addProfile => 'Add Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get deleteProfile => 'Delete Profile';

  @override
  String deleteProfileConfirmation(String name) {
    return 'Are you sure you want to delete $name? This action cannot be undone.';
  }

  @override
  String get profileName => 'Profile Name';

  @override
  String get enterProfileName => 'Enter profile name';

  @override
  String restrictionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count restrictions',
      one: '1 restriction',
      zero: 'No restrictions',
    );
    return '$_temp0';
  }

  @override
  String profileRestrictions(String name) {
    return '$name\'s Restrictions';
  }

  @override
  String get noRestrictionsYet => 'No restrictions yet';

  @override
  String get addFoodItemsToRestrict => 'Add food items to restrict';

  @override
  String get addRestriction => 'Add Restriction';

  @override
  String get editRestriction => 'Edit Restriction';

  @override
  String get addFoodRestriction => 'Add Food Restriction';

  @override
  String get commonAllergens => 'Common Allergens';

  @override
  String get allIngredients => 'All Ingredients';

  @override
  String get search => 'Search';

  @override
  String get searchIngredients => 'Search Ingredients';

  @override
  String get typeToSearch => 'Type to search...';

  @override
  String get typeAtLeastTwoChars => 'Type at least 2 characters to search';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get itemAlreadyInRestrictions => 'This item is already in your restrictions';

  @override
  String get category => 'Category';

  @override
  String get severity => 'Severity';

  @override
  String get allergen => 'Allergen';

  @override
  String get dietary => 'Dietary';

  @override
  String get religious => 'Religious';

  @override
  String get medical => 'Medical';

  @override
  String get high => 'High';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get scanProduct => 'Scan Product';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get enterEanCode => 'Enter EAN Code';

  @override
  String get eanCode => 'EAN Code';

  @override
  String get enterEanDigits => 'Enter 8 or 13 digit code';

  @override
  String get verify => 'Verify';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get scanAgain => 'Scan Again';

  @override
  String get noActiveProfile => 'No active profile - restrictions not checked';

  @override
  String get setProfile => 'Set Profile';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get noIngredientsInfo => 'No ingredients information available';

  @override
  String get allergens => 'Allergens';

  @override
  String get noAllergensInfo => 'No allergens information available';

  @override
  String get nutritionFacts => 'Nutrition Facts (per 100g)';

  @override
  String get noNutritionInfo => 'No nutrition information available';

  @override
  String get safetyCheck => 'Safety Check';

  @override
  String get noActiveProfileWithRestrictions => 'No active profile with restrictions';

  @override
  String noRestrictionsFound(String name) {
    return 'No restrictions found for $name';
  }

  @override
  String containsRestrictedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count restricted items',
      one: '1 restricted item',
    );
    return 'Contains $_temp0';
  }

  @override
  String get aboutSafeEats => 'About SafeEats';

  @override
  String get visitWebsite => 'Visit Website';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String updateAvailable(String version) {
    return 'Update to $version';
  }

  @override
  String newVersionAvailable(String version) {
    return 'New version $version available!';
  }

  @override
  String get update => 'Update';

  @override
  String get checkingForUpdates => 'Checking for updates...';

  @override
  String get upToDate => 'App is up to date';

  @override
  String get updateNow => 'Update Now';

  @override
  String get later => 'Later';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get failedToLoadAllergens => 'Failed to load allergens';

  @override
  String get failedToLoadIngredients => 'Failed to load ingredients';

  @override
  String get appDescription => 'SafeEats helps you make informed decisions about food products through barcode scanning and dietary restriction management.';

  @override
  String get barcode => 'Barcode';

  @override
  String get welcomeToSafeEats => 'Welcome to SafeEats';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get checkFoodSafety => 'Check food safety';

  @override
  String get createNewProfile => 'Create new profile';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentScans => 'No recent scans';

  @override
  String get startScanningProducts => 'Start scanning products to see your history here';

  @override
  String get home => 'Home';

  @override
  String get active => 'Active';

  @override
  String get activate => 'Activate';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get ingredientName => 'Ingredient Name';

  @override
  String get enterIngredientName => 'Enter ingredient or allergen name';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';
}
