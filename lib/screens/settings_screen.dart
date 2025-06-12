import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';
  String? _latestVersion;
  bool _updateAvailable = false;
  String? _updateNotes;
  String? _updateUrl;
  bool _checkingForUpdates = false;
  Locale? _currentLocale;
  List<Locale> _supportedLocales = [];

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
    _checkForUpdates();
    _loadLanguageSettings();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        _version = '1.0.0';
      });
    }
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      _checkingForUpdates = true;
    });

    try {
      // This is a placeholder for update checking
      // In a real app, you would check against your app store or update server
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _checkingForUpdates = false;
        _updateAvailable = false; // No updates available for now
      });
    } catch (e) {
      setState(() {
        _checkingForUpdates = false;
        _updateAvailable = false;
      });
    }
  }

  Future<void> _loadLanguageSettings() async {
    final languageService = LanguageService();
    final currentLocale = await languageService.getCurrentLocale();
    final supportedLocales = await languageService.getSupportedLocales();

    setState(() {
      _currentLocale = currentLocale;
      _supportedLocales = supportedLocales;
    });
  }

  Future<void> _changeLanguage(Locale? newLocale) async {
    if (newLocale == null) return;

    final languageService = LanguageService();
    await languageService.setLocale(newLocale);

    setState(() {
      _currentLocale = newLocale;
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _getLanguageDisplayName(Locale locale, AppLocalizations l10n) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fi':
        return 'Suomi';
      case 'es':
        return 'Español';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  String _getThemeModeDisplayName(ThemeMode themeMode, AppLocalizations l10n) {
    switch (themeMode) {
      case ThemeMode.light:
        return l10n.lightTheme;
      case ThemeMode.dark:
        return l10n.darkTheme;
      case ThemeMode.system:
        return l10n.systemTheme;
    }
  }

  Future<void> _changeThemeMode(ThemeMode themeMode) async {
    await ThemeService.instance.setThemeMode(themeMode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // Language Section
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(_currentLocale != null
                ? _getLanguageDisplayName(_currentLocale!, l10n)
                : l10n.systemDefault),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showLanguageDialog(),
          ),

          // Theme Section
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.themeMode),
            subtitle: Text(_getThemeModeDisplayName(
                ThemeService.instance.themeMode, l10n)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showThemeDialog(),
          ),
          const Divider(),

          // About Section
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.aboutSafeEats),
            subtitle: Text(l10n.appDescription),
          ),

          ListTile(
            leading: const Icon(Icons.web),
            title: Text(l10n.visitWebsite),
            subtitle: const Text('https://safeeats.app'),
            onTap: () => _launchUrl('https://safeeats.app'),
          ),

          // Version Section
          ListTile(
            leading: const Icon(Icons.system_update),
            title: Text(l10n.version(_version)),
            subtitle: _checkingForUpdates
                ? Text(l10n.checkingForUpdates)
                : _updateAvailable
                    ? Text(l10n.updateAvailable(_latestVersion ?? ''))
                    : Text(l10n.upToDate),
            trailing: _updateAvailable
                ? TextButton(
                    onPressed: () => _showUpdateDialog(),
                    child: Text(l10n.update),
                  )
                : _checkingForUpdates
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _checkForUpdates,
                      ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale?>(
              title: Text(l10n.systemDefault),
              value: null,
              groupValue: _currentLocale,
              onChanged: (value) {
                Navigator.of(context).pop();
                _changeLanguage(value);
              },
            ),
            ..._supportedLocales.map((locale) => RadioListTile<Locale?>(
                  title: Text(_getLanguageDisplayName(locale, l10n)),
                  value: locale,
                  groupValue: _currentLocale,
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    _changeLanguage(value);
                  },
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    final l10n = AppLocalizations.of(context)!;
    final currentThemeMode = ThemeService.instance.themeMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.themeMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.systemTheme),
              value: ThemeMode.system,
              groupValue: currentThemeMode,
              onChanged: (value) {
                Navigator.of(context).pop();
                if (value != null) _changeThemeMode(value);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.lightTheme),
              value: ThemeMode.light,
              groupValue: currentThemeMode,
              onChanged: (value) {
                Navigator.of(context).pop();
                if (value != null) _changeThemeMode(value);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.darkTheme),
              value: ThemeMode.dark,
              groupValue: currentThemeMode,
              onChanged: (value) {
                Navigator.of(context).pop();
                if (value != null) _changeThemeMode(value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.newVersionAvailable(_latestVersion ?? '')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_updateNotes != null) ...[
              Text(_updateNotes!),
              const SizedBox(height: 16),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.later),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (_updateUrl != null) {
                _launchUrl(_updateUrl!);
              }
            },
            child: Text(l10n.updateNow),
          ),
        ],
      ),
    );
  }
}
