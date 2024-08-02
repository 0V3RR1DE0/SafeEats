// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'restrictions_screen.dart';
import '../widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'SafeEats',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Scan Product'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Manage Restrictions'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RestrictionsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}