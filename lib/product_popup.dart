import 'package:flutter/material.dart';
import 'user_profile_provider.dart';
import 'package:provider/provider.dart';

class ProductPopup extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductPopup({required this.product});

  @override
  Widget build(BuildContext context) {
    UserProfileProvider profileProvider = Provider.of<UserProfileProvider>(context);
    List<String> restrictions = profileProvider.activeProfile?.restrictedItems ?? [];

    return AlertDialog(
      title: Text(product['name'] ?? 'No Name'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Brands: ${product['brands'] ?? 'No Brands'}'),
            SizedBox(height: 10),
            Text('Allergens: ${product['allergens'].join(', ') ?? 'No Allergens'}'),
            SizedBox(height: 10),
            Text('Ingredients:'),
            ...product['ingredients'].map<Widget>((ingredient) {
              bool isRestricted = restrictions.any((restriction) =>
                  ingredient['text'].toString().toLowerCase().contains(restriction.toLowerCase()));

              return Text(
                ingredient['text'],
                style: TextStyle(color: isRestricted ? Colors.red : Colors.black),
              );
            }).toList(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
