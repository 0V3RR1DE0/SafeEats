// lib/screens/product_details_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/storage_service.dart';
import '../services/translation_service.dart';
import '../widgets/app_scaffold.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  ProductDetailsScreen({required this.product});
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final StorageService _storageService = StorageService();
  List<String> _restrictions = [];
  bool _isLoading = true;
  bool _isSafe = false;

  @override
  void initState() {
    super.initState();
    _loadRestrictions();
  }

  Future<void> _loadRestrictions() async {
    _restrictions = await _storageService.getRestrictions();
    await _checkSafety();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _checkSafety() async {
    for (var ingredient in widget.product.ingredients) {
      for (var restriction in _restrictions) {
        final translatedRestriction = await TranslationService.translate(restriction, 'fi', 'en');
        if (ingredient.toLowerCase().contains(translatedRestriction.toLowerCase())) {
          _isSafe = false;
          return;
        }
      }
    }
    _isSafe = true;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Product Details',
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _isSafe ? 'Safe to eat' : 'Contains restricted ingredients',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isSafe ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Ingredients:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 10),
                  ...widget.product.ingredients.map((ingredient) {
                    return FutureBuilder<bool>(
                      future: _isIngredientRestricted(ingredient),
                      builder: (context, snapshot) {
                        bool isRestricted = snapshot.data ?? false;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            ingredient,
                            style: TextStyle(
                              color: isRestricted ? Colors.red : Colors.black,
                              fontWeight: isRestricted ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }

  Future<bool> _isIngredientRestricted(String ingredient) async {
    for (var restriction in _restrictions) {
      final translatedRestriction = await TranslationService.translate(restriction, 'fi', 'en');
      if (ingredient.toLowerCase().contains(translatedRestriction.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}