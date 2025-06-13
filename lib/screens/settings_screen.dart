import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';

class _VersionInfo {
  final List<int> versionParts;
  final int buildNumber;

  _VersionInfo(this.versionParts, this.buildNumber);
}

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
        // Include build number to show full version like "1.0.0-beta+3"
        _version = '${packageInfo.version}+${packageInfo.buildNumber}';
      });
    } catch (e) {
      setState(() {
        _version = '1.0.0+1';
      });
    }
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      _checkingForUpdates = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.github.com/repos/0V3RR1DE0/SafeEats/releases/latest',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestVersion = data['tag_name'] as String;
        final releaseNotes = data['body'] as String?;
        final downloadUrl = 'https://eats.netique.lol/download/';

        // Compare versions (remove 'v' prefix if present)
        final currentVersion = _version.replaceAll('v', '');
        final remoteVersion = latestVersion.replaceAll('v', '');

        final isUpdateAvailable = _isNewerVersion(
          remoteVersion,
          currentVersion,
        );

        setState(() {
          _checkingForUpdates = false;
          _updateAvailable = isUpdateAvailable;
          _latestVersion = latestVersion;
          _updateNotes = releaseNotes;
          _updateUrl = downloadUrl;
        });
      } else {
        throw Exception('Failed to fetch release info');
      }
    } catch (e) {
      setState(() {
        _checkingForUpdates = false;
        _updateAvailable = false;
      });
    }
  }

  bool _isNewerVersion(String remoteVersion, String currentVersion) {
    try {
      // Parse versions like "1.0.0-beta+1" or "1.0.0"
      final remoteParsed = _parseVersionString(remoteVersion);
      final currentParsed = _parseVersionString(currentVersion);

      // Compare major.minor.patch first
      for (int i = 0; i < 3; i++) {
        if (remoteParsed.versionParts[i] > currentParsed.versionParts[i])
          return true;
        if (remoteParsed.versionParts[i] < currentParsed.versionParts[i])
          return false;
      }

      // If versions are equal, compare build numbers
      return remoteParsed.buildNumber > currentParsed.buildNumber;
    } catch (e) {
      return false; // Error parsing versions
    }
  }

  _VersionInfo _parseVersionString(String version) {
    // Remove 'v' prefix if present
    final cleanVersion = version.replaceAll('v', '');

    // Split by '+' to separate build number
    final parts = cleanVersion.split('+');
    final versionPart = parts[0];
    final buildNumber = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    // Split version part by '-' to remove pre-release suffix
    final versionOnly = versionPart.split('-')[0];

    // Parse major.minor.patch
    final versionParts = versionOnly.split('.');
    final major =
        int.tryParse(versionParts.length > 0 ? versionParts[0] : '0') ?? 0;
    final minor =
        int.tryParse(versionParts.length > 1 ? versionParts[1] : '0') ?? 0;
    final patch =
        int.tryParse(versionParts.length > 2 ? versionParts[2] : '0') ?? 0;

    return _VersionInfo([major, minor, patch], buildNumber);
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
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Force external browser
      );
    } else {
      // Show error if URL can't be launched
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getLanguageDisplayName(Locale locale, AppLocalizations l10n) {
    final languageService = LanguageService();
    return languageService.getLanguageDisplayName(locale);
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
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Language Section
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(
              _currentLocale != null
                  ? _getLanguageDisplayName(_currentLocale!, l10n)
                  : l10n.systemDefault,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showLanguageDialog(),
          ),

          // Theme Section
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.themeMode),
            subtitle: Text(
              _getThemeModeDisplayName(ThemeService.instance.themeMode, l10n),
            ),
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
            subtitle: const Text('https://eats.netique.lol'),
            onTap: () => _launchUrl('https://eats.netique.lol'),
          ),

          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Support Development'),
            subtitle: const Text('Donation options coming soon!'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showDonationDialog(),
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
            onLongPress: () => _showVersionInfoDialog(),
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
            ..._supportedLocales.map(
              (locale) => RadioListTile<Locale?>(
                title: Text(_getLanguageDisplayName(locale, l10n)),
                value: locale,
                groupValue: _currentLocale,
                onChanged: (value) {
                  Navigator.of(context).pop();
                  _changeLanguage(value);
                },
              ),
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

  void _showDonationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Support Development'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thank you for considering supporting SafeEats development!'),
            SizedBox(height: 16),
            Text(
                'Donation options are coming soon. We\'re working on setting up various ways for you to support the project.'),
            SizedBox(height: 16),
            Text('In the meantime, you can help by:'),
            SizedBox(height: 8),
            Text('• Starring the project on GitHub'),
            Text('• Sharing SafeEats with friends'),
            Text('• Reporting bugs and suggesting features'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _launchUrl('https://github.com/0V3RR1DE0/SafeEats');
            },
            child: const Text('Visit GitHub'),
          ),
        ],
      ),
    );
  }

  void _showVersionInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Version Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How Version Checking Works:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('1. Current Version:'),
              Text('   $_version',
                  style: const TextStyle(fontFamily: 'monospace')),
              const SizedBox(height: 8),
              const Text('2. Check Process:'),
              const Text('   • App queries GitHub API for latest release'),
              const Text(
                  '   • URL: api.github.com/repos/0V3RR1DE0/SafeEats/releases/latest'),
              const Text('   • Compares version numbers automatically'),
              const SizedBox(height: 8),
              const Text('3. Version Format:'),
              const Text('   • Format: major.minor.patch-type+build'),
              const Text('   • Example: 1.0.0-beta+3'),
              const Text('   • +3 = build number (for APK installation)'),
              const SizedBox(height: 8),
              const Text('4. Update Detection:'),
              const Text('   • Compares major.minor.patch numbers'),
              const Text('   • Ignores pre-release suffixes (-beta, -alpha)'),
              const Text(
                  '   • Shows "Update Available" if newer version found'),
              const SizedBox(height: 8),
              const Text('5. Manual Updates:'),
              const Text('   • SafeEats is sideloaded (not from Play Store)'),
              const Text('   • Updates require manual APK download/install'),
              const Text('   • "Update" button opens download page'),
              const SizedBox(height: 12),
              if (_latestVersion != null) ...[
                const Text(
                  'Latest Available:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('   $_latestVersion',
                    style: const TextStyle(fontFamily: 'monospace')),
                const SizedBox(height: 8),
              ],
              const Text(
                'Tip: Long press this version section to see this info!',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (_updateUrl != null)
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                _launchUrl(_updateUrl!);
              },
              child: const Text('Download Page'),
            ),
        ],
      ),
    );
  }
}
