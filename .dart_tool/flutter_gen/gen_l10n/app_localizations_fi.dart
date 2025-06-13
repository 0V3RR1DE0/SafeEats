// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'SafeEats';

  @override
  String get scan => 'Skannaa';

  @override
  String get profiles => 'Profiilit';

  @override
  String get settings => 'Asetukset';

  @override
  String get noProfilesYet => 'Ei profiileja vielä';

  @override
  String get addProfileToStart => 'Lisää profiili aloittaaksesi';

  @override
  String get addProfile => 'Lisää profiili';

  @override
  String get editProfile => 'Muokkaa profiilia';

  @override
  String get deleteProfile => 'Poista profiili';

  @override
  String deleteProfileConfirmation(String name) {
    return 'Haluatko varmasti poistaa profiilin $name? Tätä toimintoa ei voi peruuttaa.';
  }

  @override
  String get profileName => 'Profiilin nimi';

  @override
  String get enterProfileName => 'Syötä profiilin nimi';

  @override
  String restrictionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rajoitusta',
      one: '1 rajoitus',
      zero: 'Ei rajoituksia',
    );
    return '$_temp0';
  }

  @override
  String profileRestrictions(String name) {
    return '${name}n rajoitukset';
  }

  @override
  String get noRestrictionsYet => 'Ei rajoituksia vielä';

  @override
  String get addFoodItemsToRestrict => 'Lisää ruoka-aineita rajoitettavaksi';

  @override
  String get addRestriction => 'Lisää rajoitus';

  @override
  String get editRestriction => 'Muokkaa rajoitusta';

  @override
  String get addFoodRestriction => 'Lisää ruokarajoitus';

  @override
  String get commonAllergens => 'Yleiset allergeenit';

  @override
  String get allIngredients => 'Kaikki ainesosat';

  @override
  String get search => 'Haku';

  @override
  String get searchIngredients => 'Hae ainesosia';

  @override
  String get typeToSearch => 'Kirjoita hakeaksesi...';

  @override
  String get typeAtLeastTwoChars => 'Kirjoita vähintään 2 merkkiä hakeaksesi';

  @override
  String get noResultsFound => 'Ei tuloksia löytynyt';

  @override
  String get itemAlreadyInRestrictions => 'Tämä tuote on jo rajoituksissasi';

  @override
  String get category => 'Kategoria';

  @override
  String get severity => 'Vakavuus';

  @override
  String get allergen => 'Allergeeni';

  @override
  String get dietary => 'Ruokavalio';

  @override
  String get religious => 'Uskonnollinen';

  @override
  String get medical => 'Lääketieteellinen';

  @override
  String get high => 'Korkea';

  @override
  String get medium => 'Keskitaso';

  @override
  String get low => 'Matala';

  @override
  String get add => 'Lisää';

  @override
  String get save => 'Tallenna';

  @override
  String get cancel => 'Peruuta';

  @override
  String get delete => 'Poista';

  @override
  String get scanProduct => 'Skannaa tuote';

  @override
  String get manualEntry => 'Manuaalinen syöttö';

  @override
  String get enterEanCode => 'Syötä EAN-koodi';

  @override
  String get eanCode => 'EAN-koodi';

  @override
  String get enterEanDigits => 'Syötä 8 tai 13 numeron koodi';

  @override
  String get verify => 'Vahvista';

  @override
  String get productNotFound => 'Tuotetta ei löytynyt';

  @override
  String get scanAgain => 'Skannaa uudelleen';

  @override
  String get noActiveProfile => 'Ei aktiivista profiilia - rajoituksia ei tarkisteta';

  @override
  String get setProfile => 'Aseta profiili';

  @override
  String get ingredients => 'Ainesosat';

  @override
  String get noIngredientsInfo => 'Ainesosatietoja ei saatavilla';

  @override
  String get allergens => 'Allergeenit';

  @override
  String get noAllergensInfo => 'Allergeenietoja ei saatavilla';

  @override
  String get nutritionFacts => 'Ravintosisältö (per 100g)';

  @override
  String get noNutritionInfo => 'Ravintotietoja ei saatavilla';

  @override
  String get safetyCheck => 'Turvallisuustarkistus';

  @override
  String get noActiveProfileWithRestrictions => 'Ei aktiivista profiilia rajoituksineen';

  @override
  String noRestrictionsFound(String name) {
    return 'Ei rajoituksia löytynyt käyttäjälle $name';
  }

  @override
  String containsRestrictedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rajoitettua tuotetta',
      one: '1 rajoitetun tuotteen',
    );
    return 'Sisältää $_temp0';
  }

  @override
  String get aboutSafeEats => 'Tietoja SafeEats-sovelluksesta';

  @override
  String get visitWebsite => 'Käy verkkosivulla';

  @override
  String version(String version) {
    return 'Versio $version';
  }

  @override
  String updateAvailable(String version) {
    return 'Päivitä versioon $version';
  }

  @override
  String newVersionAvailable(String version) {
    return 'Uusi versio $version saatavilla!';
  }

  @override
  String get update => 'Päivitä';

  @override
  String get checkingForUpdates => 'Tarkistetaan päivityksiä...';

  @override
  String get upToDate => 'Sovellus on ajan tasalla';

  @override
  String get updateNow => 'Päivitä nyt';

  @override
  String get later => 'Myöhemmin';

  @override
  String get language => 'Kieli';

  @override
  String get systemDefault => 'Järjestelmän oletus';

  @override
  String get failedToLoadAllergens => 'Allergeenien lataus epäonnistui';

  @override
  String get failedToLoadIngredients => 'Ainesosien lataus epäonnistui';

  @override
  String get appDescription => 'SafeEats auttaa tekemään tietoisia päätöksiä elintarvikkeista viivakoodin skannauksen ja ruokavaliorajoitusten hallinnan avulla.';

  @override
  String get barcode => 'Viivakoodi';

  @override
  String get welcomeToSafeEats => 'Tervetuloa SafeEats-sovellukseen';

  @override
  String get quickActions => 'Pikatoiminnot';

  @override
  String get checkFoodSafety => 'Tarkista ruoan turvallisuus';

  @override
  String get createNewProfile => 'Luo uusi profiili';

  @override
  String get recentActivity => 'Viimeaikainen toiminta';

  @override
  String get noRecentScans => 'Ei viimeaikaisia skannauksia';

  @override
  String get startScanningProducts => 'Aloita tuotteiden skannaus nähdäksesi historiasi täällä';

  @override
  String get home => 'Koti';

  @override
  String get active => 'Aktiivinen';

  @override
  String get activate => 'Aktivoi';

  @override
  String get deactivate => 'Poista käytöstä';

  @override
  String get ingredientName => 'Ainesosan nimi';

  @override
  String get enterIngredientName => 'Syötä ainesosan tai allergeenin nimi';

  @override
  String get darkMode => 'Tumma tila';

  @override
  String get themeMode => 'Teeman tila';

  @override
  String get lightTheme => 'Vaalea';

  @override
  String get darkTheme => 'Tumma';

  @override
  String get systemTheme => 'Järjestelmä';
}
