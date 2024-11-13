import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final String barcode;
  final String name;
  final String brand;
  final List<String> ingredients;
  final List<String> allergens;
  final String? imageUrl;
  final String? nutriScore;
  final Map<String, dynamic> nutriments;

  Product({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.ingredients,
    required this.allergens,
    this.imageUrl,
    this.nutriScore,
    required this.nutriments,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final product = json['product'];

    // Extract ingredients list
    List<String> ingredientsList = [];
    if (product['ingredients_text_en'] != null) {
      ingredientsList = product['ingredients_text_en']
          .toString()
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList()
          .cast<String>();
    } else if (product['ingredients_text'] != null) {
      ingredientsList = product['ingredients_text']
          .toString()
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList()
          .cast<String>();
    }

    // Extract allergens
    List<String> allergensList = [];
    if (product['allergens_tags'] != null) {
      allergensList = (product['allergens_tags'] as List)
          .map((e) => e.toString().replaceAll('en:', ''))
          .toList()
          .cast<String>();
    }

    return Product(
      barcode: json['code'] ?? '',
      name: product['product_name'] ??
          product['product_name_en'] ??
          'Unknown Product',
      brand: product['brands'] ?? 'Unknown Brand',
      ingredients: ingredientsList,
      allergens: allergensList,
      imageUrl: product['image_url'],
      nutriScore: product['nutriscore_grade']?.toUpperCase(),
      nutriments: product['nutriments'] ?? {},
    );
  }

  bool containsRestriction(String restriction) {
    final restrictionLower = restriction.toLowerCase();

    // Check ingredients
    for (final ingredient in ingredients) {
      if (ingredient.toLowerCase().contains(restrictionLower)) {
        return true;
      }
    }

    // Check allergens
    for (final allergen in allergens) {
      if (allergen.toLowerCase().contains(restrictionLower)) {
        return true;
      }
    }

    return false;
  }

  List<String> getMatchingRestrictions(List<String> restrictions) {
    return restrictions
        .where((restriction) => containsRestriction(restriction))
        .toList();
  }
}

class ProductService {
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v2';

  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      // Clean the barcode
      final cleanBarcode = barcode.replaceAll(RegExp(r'[^0-9]'), '');

      final response = await http.get(
        Uri.parse('$_baseUrl/product/$cleanBarcode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return Product.fromJson(data);
        }
      }

      // If the first attempt fails, try the old API
      final oldApiResponse = await http.get(
        Uri.parse(
            'https://world.openfoodfacts.org/api/v0/product/$cleanBarcode.json'),
      );

      if (oldApiResponse.statusCode == 200) {
        final data = json.decode(oldApiResponse.body);
        if (data['status'] == 1) {
          return Product.fromJson(data);
        }
      }

      return null;
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  String getNutrientValue(Map<String, dynamic> nutriments, String nutrient) {
    final value = nutriments['${nutrient}_100g'];
    if (value == null) return 'N/A';

    String unit = 'g';
    if (nutrient.contains('energy')) {
      unit = 'kcal';
    } else if (nutrient.contains('salt') || nutrient.contains('sodium')) {
      unit = 'mg';
    }

    return '${value.toStringAsFixed(1)}$unit';
  }

  String formatNutrientName(String name) {
    return name
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
