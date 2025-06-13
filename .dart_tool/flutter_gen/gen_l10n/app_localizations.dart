import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fi')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'SafeEats'**
  String get appTitle;

  /// Label for scan tab
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// Label for profiles tab
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profiles;

  /// Label for settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Message shown when no profiles exist
  ///
  /// In en, this message translates to:
  /// **'No profiles yet'**
  String get noProfilesYet;

  /// Instruction to add a profile
  ///
  /// In en, this message translates to:
  /// **'Add a profile to get started'**
  String get addProfileToStart;

  /// Button to add a profile
  ///
  /// In en, this message translates to:
  /// **'Add Profile'**
  String get addProfile;

  /// Title for edit profile dialog
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Title for delete profile dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// Confirmation message for profile deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This action cannot be undone.'**
  String deleteProfileConfirmation(String name);

  /// Label for profile name field
  ///
  /// In en, this message translates to:
  /// **'Profile Name'**
  String get profileName;

  /// Hint for profile name field
  ///
  /// In en, this message translates to:
  /// **'Enter profile name'**
  String get enterProfileName;

  /// Count of restrictions in a profile
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No restrictions} =1{1 restriction} other{{count} restrictions}}'**
  String restrictionsCount(int count);

  /// Title for profile restrictions screen
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Restrictions'**
  String profileRestrictions(String name);

  /// Message shown when no restrictions exist
  ///
  /// In en, this message translates to:
  /// **'No restrictions yet'**
  String get noRestrictionsYet;

  /// Instruction to add food restrictions
  ///
  /// In en, this message translates to:
  /// **'Add food items to restrict'**
  String get addFoodItemsToRestrict;

  /// Button to add a restriction
  ///
  /// In en, this message translates to:
  /// **'Add Restriction'**
  String get addRestriction;

  /// Title for edit restriction dialog
  ///
  /// In en, this message translates to:
  /// **'Edit Restriction'**
  String get editRestriction;

  /// Title for add food restriction dialog
  ///
  /// In en, this message translates to:
  /// **'Add Food Restriction'**
  String get addFoodRestriction;

  /// Tab title for common allergens
  ///
  /// In en, this message translates to:
  /// **'Common Allergens'**
  String get commonAllergens;

  /// Tab title for all ingredients
  ///
  /// In en, this message translates to:
  /// **'All Ingredients'**
  String get allIngredients;

  /// Tab title for search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Label for ingredient search field
  ///
  /// In en, this message translates to:
  /// **'Search Ingredients'**
  String get searchIngredients;

  /// Hint for search field
  ///
  /// In en, this message translates to:
  /// **'Type to search...'**
  String get typeToSearch;

  /// Message to type at least 2 characters
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters to search'**
  String get typeAtLeastTwoChars;

  /// Message when no search results are found
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// Message when item already exists in restrictions
  ///
  /// In en, this message translates to:
  /// **'This item is already in your restrictions'**
  String get itemAlreadyInRestrictions;

  /// Label for category dropdown
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Label for severity dropdown
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// Category name for allergen
  ///
  /// In en, this message translates to:
  /// **'Allergen'**
  String get allergen;

  /// Category name for dietary
  ///
  /// In en, this message translates to:
  /// **'Dietary'**
  String get dietary;

  /// Category name for religious
  ///
  /// In en, this message translates to:
  /// **'Religious'**
  String get religious;

  /// Category name for medical
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get medical;

  /// Severity level high
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Severity level medium
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Severity level low
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Button label for add
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Button label for save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Button label for cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button label for delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Title for scan product screen
  ///
  /// In en, this message translates to:
  /// **'Scan Product'**
  String get scanProduct;

  /// Button for manual barcode entry
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// Title for manual EAN entry dialog
  ///
  /// In en, this message translates to:
  /// **'Enter EAN Code'**
  String get enterEanCode;

  /// Label for EAN code field
  ///
  /// In en, this message translates to:
  /// **'EAN Code'**
  String get eanCode;

  /// Hint for EAN code field
  ///
  /// In en, this message translates to:
  /// **'Enter 8 or 13 digit code'**
  String get enterEanDigits;

  /// Button to verify EAN code
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Message when product is not found
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// Button to scan another product
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scanAgain;

  /// Warning when no active profile is set
  ///
  /// In en, this message translates to:
  /// **'No active profile - restrictions not checked'**
  String get noActiveProfile;

  /// Button to set active profile
  ///
  /// In en, this message translates to:
  /// **'Set Profile'**
  String get setProfile;

  /// Label for ingredients section
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// Message when no ingredients info is available
  ///
  /// In en, this message translates to:
  /// **'No ingredients information available'**
  String get noIngredientsInfo;

  /// Label for allergens section
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get allergens;

  /// Message when no allergens info is available
  ///
  /// In en, this message translates to:
  /// **'No allergens information available'**
  String get noAllergensInfo;

  /// Label for nutrition facts section
  ///
  /// In en, this message translates to:
  /// **'Nutrition Facts (per 100g)'**
  String get nutritionFacts;

  /// Message when no nutrition info is available
  ///
  /// In en, this message translates to:
  /// **'No nutrition information available'**
  String get noNutritionInfo;

  /// Label for safety check section
  ///
  /// In en, this message translates to:
  /// **'Safety Check'**
  String get safetyCheck;

  /// Message when no active profile has restrictions
  ///
  /// In en, this message translates to:
  /// **'No active profile with restrictions'**
  String get noActiveProfileWithRestrictions;

  /// Message when no restrictions are found for profile
  ///
  /// In en, this message translates to:
  /// **'No restrictions found for {name}'**
  String noRestrictionsFound(String name);

  /// Warning about restricted items
  ///
  /// In en, this message translates to:
  /// **'Contains {count, plural, =1{1 restricted item} other{{count} restricted items}}'**
  String containsRestrictedItems(int count);

  /// Label for about section
  ///
  /// In en, this message translates to:
  /// **'About SafeEats'**
  String get aboutSafeEats;

  /// Label for visit website button
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get visitWebsite;

  /// App version display
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// Update notification
  ///
  /// In en, this message translates to:
  /// **'Update to {version}'**
  String updateAvailable(String version);

  /// New version notification
  ///
  /// In en, this message translates to:
  /// **'New version {version} available!'**
  String newVersionAvailable(String version);

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Message when checking for updates
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

  /// Message when app is up to date
  ///
  /// In en, this message translates to:
  /// **'App is up to date'**
  String get upToDate;

  /// Button to update app
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// Button to postpone update
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// Label for language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Option for system default language
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Error message when allergens can't be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to load allergens'**
  String get failedToLoadAllergens;

  /// Error message when ingredients can't be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to load ingredients'**
  String get failedToLoadIngredients;

  /// Description of the app
  ///
  /// In en, this message translates to:
  /// **'SafeEats helps you make informed decisions about food products through barcode scanning and dietary restriction management.'**
  String get appDescription;

  /// Label for barcode field
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// Welcome message on home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to SafeEats'**
  String get welcomeToSafeEats;

  /// Section title for quick actions
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Subtitle for scan product action
  ///
  /// In en, this message translates to:
  /// **'Check food safety'**
  String get checkFoodSafety;

  /// Subtitle for add profile action
  ///
  /// In en, this message translates to:
  /// **'Create new profile'**
  String get createNewProfile;

  /// Section title for recent activity
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// Message when no recent scans exist
  ///
  /// In en, this message translates to:
  /// **'No recent scans'**
  String get noRecentScans;

  /// Instruction for recent scans section
  ///
  /// In en, this message translates to:
  /// **'Start scanning products to see your history here'**
  String get startScanningProducts;

  /// Label for home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Label for active profile badge
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Button to activate profile
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// Button to deactivate profile
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// Label for ingredient name field
  ///
  /// In en, this message translates to:
  /// **'Ingredient Name'**
  String get ingredientName;

  /// Hint for ingredient name field
  ///
  /// In en, this message translates to:
  /// **'Enter ingredient or allergen name'**
  String get enterIngredientName;

  /// Label for dark mode setting
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label for theme mode setting
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fi': return AppLocalizationsFi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
