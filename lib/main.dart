import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_home_page.dart';
import 'user_profile_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProfileProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeEats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
