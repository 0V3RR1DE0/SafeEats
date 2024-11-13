import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safeeats/main.dart';
import 'package:safeeats/screens/scan_screen.dart';
import 'package:safeeats/screens/profiles_screen.dart';
import 'package:safeeats/screens/settings_screen.dart';

void main() {
  testWidgets('SafeEats app navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const SafeEatsApp());
    await tester.pumpAndSettle();

    // Initially, scan screen should be visible
    expect(find.byType(ScanScreen), findsOneWidget);

    // Navigate to profiles screen
    await tester.tap(find.text('Profiles'));
    await tester.pumpAndSettle();

    // Verify profiles screen is visible
    expect(find.byType(ProfilesScreen), findsOneWidget);

    // Navigate to settings screen
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Verify settings screen is visible
    expect(find.byType(SettingsScreen), findsOneWidget);

    // Navigate back to scan screen
    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();

    // Verify scan screen is visible again
    expect(find.byType(ScanScreen), findsOneWidget);

    // Verify navigation bar is always present
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(3));
  });
}
