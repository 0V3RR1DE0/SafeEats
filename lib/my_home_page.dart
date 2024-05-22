import 'package:flutter/material.dart';
import 'barcode_scanner_widget.dart';
import 'settings_screen.dart';
import 'manual_input_screen.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            SizedBox(width: 10),
            Text('SafeEats'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome to SafeEats!',
          ),
          SizedBox(height: 20),
          Expanded(
            child: BarcodeScannerWidget(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManualInputScreen()),
              );
            },
            child: Text('Enter EAN/UCP Code Manually'),
          ),
        ],
      ),
    );
  }
}
