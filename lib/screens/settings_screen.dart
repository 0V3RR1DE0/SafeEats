import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';
  String? _latestVersion;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
    _checkForUpdates();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> _checkForUpdates() async {
    try {
      final response = await http.get(Uri.parse(
        'https://api.github.com/repos/0v3rr1de0/safeeats/releases/latest',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestVersion = data['tag_name'].toString().replaceAll('v', '');

        setState(() {
          _latestVersion = latestVersion;
        });

        if (_version != _latestVersion && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New version $_latestVersion available!'),
              action: SnackBarAction(
                label: 'Update',
                onPressed: () => _launchUrl(
                  'https://github.com/0v3rr1de0/safeeats/releases/latest',
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error checking for updates: $e');
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open URL')),
        );
      }
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'SafeEats',
        applicationVersion: 'v$_version',
        applicationIcon: Image.asset(
          'assets/images/app_icon.png',
          width: 50,
          height: 50,
        ),
        children: [
          const Text(
            'SafeEats helps you make informed decisions about food products '
            'through barcode scanning and dietary restriction management.',
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => _launchUrl('https://eats.netique.lol'),
            child: const Text('Visit Website'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  title: const Text('About SafeEats'),
                  leading: const Icon(Icons.info_outline),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showAboutDialog,
                ),
                const Divider(),
                ListTile(
                  title: const Text('Visit Website'),
                  leading: const Icon(Icons.language),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _launchUrl('https://eats.netique.lol'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  'Version $_version',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (_latestVersion != null && _latestVersion != _version)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton(
                      onPressed: () => _launchUrl(
                        'https://github.com/0v3rr1de0/safeeats/releases/latest',
                      ),
                      child: Text(
                        'Update to $_latestVersion',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
