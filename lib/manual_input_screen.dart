import 'package:flutter/material.dart';
import 'food_service.dart';
import 'product_popup.dart';
import 'user_profile_provider.dart';
import 'package:provider/provider.dart';
import 'product_info_page.dart';

class ManualInputScreen extends StatelessWidget {
  final TextEditingController _eanController = TextEditingController();
  final FoodService _foodService = FoodService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter EAN/UCP Code Manually'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _eanController,
              decoration: InputDecoration(
                labelText: 'Enter EAN/UCP Code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final code = _eanController.text;
                if (code.isNotEmpty) {
                  try {
                    final productData = await _foodService.fetchProductData(code);
                    if (productData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductInfoPage(product: productData)),
                      );
                      } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product not found')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: Text('Fetch Product Data'),
            ),
          ],
        ),
      ),
    );
  }
}
