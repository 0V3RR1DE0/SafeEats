PS F:\Dev\Android\safeeats> flutter run
Connected devices:
moto g75 5G (mobile)         • ZY22KM3GKS    • android-arm64 • Android 14 (API 34)
sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64   • Android 13 (API 33) (emulator)
[1]: moto g75 5G (ZY22KM3GKS)
[2]: sdk gphone64 x86 64 (emulator-5554)
Please choose one (or "q" to quit): 2
Launching lib\main.dart on sdk gphone64 x86 64 in debug mode...
lib/main.dart:3:8: Error: Error when reading '.dart_tool/flutter_gen/gen_l10n/app_localizations.dart': The system cannot find the path specified.

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
       ^
lib/screens/home_screen.dart:2:8: Error: Error when reading '.dart_tool/flutter_gen/gen_l10n/app_localizations.dart': The system cannot find the path specified.

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
       ^
lib/screens/scan_screen.dart:3:8: Error: Error when reading '.dart_tool/flutter_gen/gen_l10n/app_localizations.dart': The system cannot find the path specified.

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
       ^
lib/screens/profiles_screen.dart:2:8: Error: Error when reading '.dart_tool/flutter_gen/gen_l10n/app_localizations.dart': The system cannot find the path specified.

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
       ^
lib/screens/settings_screen.dart:46:57: Error: Can't find '}' to match '{'.
  Future<void> _changeLanguage(Locale? newLocale) async {
                                                        ^
lib/screens/settings_screen.dart:17:58: Error: Can't find '}' to match '{'.
class _SettingsScreenState extends State<SettingsScreen> {
                                                         ^
lib/screens/settings_screen.dart:2:8: Error: Error when reading '.dart_tool/flutter_gen/gen_l10n/app_localizations.dart': The system cannot find the path specified.

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
       ^
lib/models/profile.dart:3:8: Error: Error when reading '.dart_tool/flutter_gen/gen_l10n/app_localizations.dart': The system cannot find the path specified.

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
       ^
lib/screens/restrictions_screen.dart:2:8: Error: Error when reading '.dart_tool/flutter_gen/gen_l10n/app_localizations.dart': The system cannot find the path specified.

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
       ^
lib/screens/restrictions_screen.dart:5:8: Error: Error when reading 'lib/screens/restriction_dialog.dart': The system cannot find the file specified.

import 'restriction_dialog.dart';
       ^
lib/screens/settings_screen.dart:17:7: Error: The non-abstract class '_SettingsScreenState' is missing implementations for these members:
 - State.build
Try to either
 - provide an implementation,
 - inherit an implementation from a superclass or mixin,
 - mark the class as abstract, or
 - provide a 'noSuchMethod' implementation.

class _SettingsScreenState extends State<SettingsScreen> {
      ^^^^^^^^^^^^^^^^^^^^
/C:/Users/Bok/flutter/flutter/packages/flutter/lib/src/widgets/framework.dart:1471:10: Context: 'State.build' is defined here.
  Widget build(BuildContext context);
         ^^^^^
lib/main.dart:49:9: Error: Undefined name 'AppLocalizations'.
        AppLocalizations.delegate,
        ^^^^^^^^^^^^^^^^
lib/main.dart:54:25: Error: The getter 'AppLocalizations' isn't defined for the class '_SafeEatsAppState'.
 - '_SafeEatsAppState' is from 'package:safeeats/main.dart' ('lib/main.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
      supportedLocales: AppLocalizations.supportedLocales,
                        ^^^^^^^^^^^^^^^^
lib/screens/home_screen.dart:19:18: Error: The getter 'AppLocalizations' isn't defined for the class '_HomeScreenState'.
 - '_HomeScreenState' is from 'package:safeeats/screens/home_screen.dart' ('lib/screens/home_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/scan_screen.dart:47:18: Error: The getter 'AppLocalizations' isn't defined for the class '_ScanScreenState'.
 - '_ScanScreenState' is from 'package:safeeats/screens/scan_screen.dart' ('lib/screens/scan_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/scan_screen.dart:87:18: Error: The getter 'AppLocalizations' isn't defined for the class '_ScanScreenState'.
 - '_ScanScreenState' is from 'package:safeeats/screens/scan_screen.dart' ('lib/screens/scan_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/scan_screen.dart:124:18: Error: The getter 'AppLocalizations' isn't defined for the class '_ScanScreenState'.
 - '_ScanScreenState' is from 'package:safeeats/screens/scan_screen.dart' ('lib/screens/scan_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/scan_screen.dart:221:18: Error: The getter 'AppLocalizations' isn't defined for the class 'ProductDetailsSheet'.
 - 'ProductDetailsSheet' is from 'package:safeeats/screens/scan_screen.dart' ('lib/screens/scan_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/scan_screen.dart:428:18: Error: The getter 'AppLocalizations' isn't defined for the class 'ProductDetailsSheet'.
 - 'ProductDetailsSheet' is from 'package:safeeats/screens/scan_screen.dart' ('lib/screens/scan_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/profiles_screen.dart:75:18: Error: The getter 'AppLocalizations' isn't defined for the class '_ProfilesScreenState'.
 - '_ProfilesScreenState' is from 'package:safeeats/screens/profiles_screen.dart' ('lib/screens/profiles_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/profiles_screen.dart:169:18: Error: The getter 'AppLocalizations' isn't defined for the class '_ProfilesScreenState'.
 - '_ProfilesScreenState' is from 'package:safeeats/screens/profiles_screen.dart' ('lib/screens/profiles_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/profiles_screen.dart:210:18: Error: The getter 'AppLocalizations' isn't defined for the class '_ProfilesScreenState'.
 - '_ProfilesScreenState' is from 'package:safeeats/screens/profiles_screen.dart' ('lib/screens/profiles_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/profiles_screen.dart:251:18: Error: The getter 'AppLocalizations' isn't defined for the class '_ProfilesScreenState'.
 - '_ProfilesScreenState' is from 'package:safeeats/screens/profiles_screen.dart' ('lib/screens/profiles_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/settings_screen.dart:30:5: Error: The method '_loadAppInfo' isn't defined for the class '_SettingsScreenState'.
 - '_SettingsScreenState' is from 'package:safeeats/screens/settings_screen.dart' ('lib/screens/settings_screen.dart').
Try correcting the name to the name of an existing method, or defining a method named '_loadAppInfo'.
    _loadAppInfo();
    ^^^^^^^^^^^^
lib/screens/settings_screen.dart:31:5: Error: The method '_checkForUpdates' isn't defined for the class '_SettingsScreenState'.
 - '_SettingsScreenState' is from 'package:safeeats/screens/settings_screen.dart' ('lib/screens/settings_screen.dart').
Try correcting the name to the name of an existing method, or defining a method named '_checkForUpdates'.
    _checkForUpdates();
    ^^^^^^^^^^^^^^^^
lib/models/profile.dart:116:18: Error: The getter 'AppLocalizations' isn't defined for the class 'RestrictionCategory'.
 - 'RestrictionCategory' is from 'package:safeeats/models/profile.dart' ('lib/models/profile.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/models/profile.dart:138:18: Error: The getter 'AppLocalizations' isn't defined for the class 'RestrictionSeverity'.
 - 'RestrictionSeverity' is from 'package:safeeats/models/profile.dart' ('lib/models/profile.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
lib/screens/restrictions_screen.dart:89:26: Error: The method 'showRestrictionDialog' isn't defined for the class '_RestrictionsScreenState'.
 - '_RestrictionsScreenState' is from 'package:safeeats/screens/restrictions_screen.dart' ('lib/screens/restrictions_screen.dart').
Try correcting the name to the name of an existing method, or defining a method named 'showRestrictionDialog'.
    final result = await showRestrictionDialog(
                         ^^^^^^^^^^^^^^^^^^^^^
lib/screens/restrictions_screen.dart:104:26: Error: The method 'showEditRestrictionDialog' isn't defined for the class '_RestrictionsScreenState'.
 - '_RestrictionsScreenState' is from 'package:safeeats/screens/restrictions_screen.dart' ('lib/screens/restrictions_screen.dart').
Try correcting the name to the name of an existing method, or defining a method named 'showEditRestrictionDialog'.
    final result = await showEditRestrictionDialog(
                         ^^^^^^^^^^^^^^^^^^^^^^^^^
lib/screens/restrictions_screen.dart:116:18: Error: The getter 'AppLocalizations' isn't defined for the class '_RestrictionsScreenState'.
 - '_RestrictionsScreenState' is from 'package:safeeats/screens/restrictions_screen.dart' ('lib/screens/restrictions_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppLocalizations'.
    final l10n = AppLocalizations.of(context)!;
                 ^^^^^^^^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command 'C:\Users\Bok\flutter\flutter\bin\flutter.bat'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 9s
Running Gradle task 'assembleDebug'...                             10.5s
Error: Gradle task assembleDebug failed with exit code 1
PS F:\Dev\Android\safeeats> 