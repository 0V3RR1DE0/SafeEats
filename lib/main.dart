// lib/main.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'screens/home_screen.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    print('App initializing...');
   
    runApp(SafeEatsApp());
  }, (error, stackTrace) {
    print('Caught error: $error');
    print('Stack trace: $stackTrace');
  });
}

class SafeEatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building SafeEatsApp');
    return MaterialApp(
      title: 'SafeEats',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Corrected from primary
            foregroundColor: Colors.white, // Corrected from onPrimary
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
