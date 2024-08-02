// lib/services/open_food_facts_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class OpenFoodFactsApiService {
  Future<Product> getProductInfo(String barcode) async {
    final response = await http.get(Uri.parse(
        'https://world.openfoodfacts.org/api/v2/product/$barcode.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Product.fromJson(data['product']);
    } else {
      throw Exception('Failed to load product info');
    }
  }
}