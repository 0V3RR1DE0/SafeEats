import 'package:flutter/material.dart';
import 'user_profile_provider.dart';
import 'package:provider/provider.dart';

class ProductInfoPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductInfoPage({required this.product});

  @override
  Widget build(BuildContext context) {
    UserProfileProvider profileProvider = Provider.of<UserProfileProvider>(context);
    List<String> restrictions = profileProvider.activeProfile?.restrictedItems ?? [];

    // Ensure 'allergens' is always a List<String>
    List<String> allergens = (product['allergens'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Information'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Name: ${product['name'] ?? 'Unknown'}'),
          ),
          ListTile(
            title: Text('Brands: ${product['brands'] ?? 'Unknown'}'),
          ),
          ListTile(
            title: Text('Allergens: ${allergens.join(', ')}'), // Use the 'allergens' variable
          ),
          ListTile(
            title: Text('Ingredients:'),
          ),
          ...product['ingredients'].map<Widget>((ingredient) {
            bool isRestricted = restrictions.any((restriction) =>
                ingredient['text'].toString().toLowerCase().contains(restriction.toLowerCase()));

            return ListTile(
              title: Text(
                ingredient['text'],
                style: TextStyle(color: isRestricted ? Colors.red : Colors.black),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
