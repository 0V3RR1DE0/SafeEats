import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodService {
  final String baseUrl = 'https://world.openfoodfacts.org/api/v0/product/';

  Future<Map<String, dynamic>?> fetchProductData(String barcode) async {
    final response = await http.get(Uri.parse('$baseUrl$barcode.json'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == 1) {
        Map<String, dynamic> product = {
          'name': data['product']['product_name'],
          'brands': data['product']['brands'],
          'allergens': data['product'].get('allergens', []),
          'allergens_from_ingredients': data['product'].get('allergens_from_ingredients', []),
          'allergens_from_user': data['product'].get('allergens_from_user', []),
          'amino_acids_tags': data['product'].get('amino_acids_tags', []),
          'ingredients': data['product'].get('ingredients', []).map((ingredient) {
            return {
              'ciqual_proxy_food_code': ingredient.get('ciqual_proxy_food_code', ''),
              'id': ingredient['id'],
              'percent_estimate': ingredient.get('percent_estimate', ''),
              'percent_max': ingredient.get('percent_max', ''),
              'percent_min': ingredient.get('percent_min', ''),
              'rank': ingredient.get('rank', ''),
              'text': ingredient['text'],
              'vegan': ingredient.get('vegan', 'Unknown'),
              'vegetarian': ingredient.get('vegetarian', 'Unknown'),
              'from_palm_oil': ingredient.get('from_palm_oil', 'No'),
              'allergens': data['product']['allergens'] != null ? List<String>.from(data['product']['allergens']) : [],
            };
          }).toList()
        };

        if (product['ingredients'].isEmpty) {
          product['ingredients'] = [{'text': 'No ingredients found'}];
        }

        return product;
      }
    }

    return null;
  }
}
