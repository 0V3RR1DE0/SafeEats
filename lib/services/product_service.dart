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
    final restrictionLower = restriction.toLowerCase().trim();

    // Check ingredients with better matching
    for (final ingredient in ingredients) {
      final ingredientLower = ingredient.toLowerCase().trim();

      // Direct contains check
      if (ingredientLower.contains(restrictionLower)) {
        return true;
      }

      // Check for common variations
      if (_isIngredientMatch(ingredientLower, restrictionLower)) {
        return true;
      }
    }

    // Check allergens with better matching
    for (final allergen in allergens) {
      final allergenLower = allergen.toLowerCase().trim();

      // Direct contains check
      if (allergenLower.contains(restrictionLower)) {
        return true;
      }

      // Check for common variations
      if (_isIngredientMatch(allergenLower, restrictionLower)) {
        return true;
      }
    }

    return false;
  }

  bool _isIngredientMatch(String ingredient, String restriction) {
    // Remove common prefixes/suffixes and check for matches
    final cleanIngredient = ingredient
        .replaceAll(RegExp(r'[0-9]+%\s*'), '') // Remove percentages
        .replaceAll(RegExp(r'[,\.]'), '') // Remove punctuation
        .trim();

    final cleanRestriction = restriction
        .replaceAll(RegExp(r'[,\.]'), '') // Remove punctuation
        .trim();

    // Check if either contains the other
    if (cleanIngredient.contains(cleanRestriction) ||
        cleanRestriction.contains(cleanIngredient)) {
      return true;
    }

    // Special handling for ingredients in parentheses (like "vegetable oils (palm sunflower)")
    final parenthesesContent = RegExp(r'\(([^)]*)\)').firstMatch(ingredient);
    if (parenthesesContent != null) {
      final contentInParens =
          parenthesesContent.group(1)?.toLowerCase().trim() ?? '';
      // Split by spaces and check each word
      final wordsInParens = contentInParens.split(RegExp(r'[\s,]+'));
      for (final word in wordsInParens) {
        if (word.isNotEmpty && cleanRestriction.contains(word)) {
          return true;
        }
        // Also check if restriction word is contained in the parentheses word
        if (word.isNotEmpty && word.contains(cleanRestriction)) {
          return true;
        }
      }
    }

    // Check for common allergen variations
    final allergenMap = {
      'peanuts': ['peanut', 'groundnut', 'arachis'],
      'peanut': ['peanuts', 'groundnut', 'arachis'],
      'tree nuts': [
        'nuts',
        'almond',
        'walnut',
        'cashew',
        'hazelnut',
        'pecan',
        'brazil nut',
        'macadamia',
        'pistachio'
      ],
      'nuts': [
        'tree nuts',
        'almond',
        'walnut',
        'cashew',
        'hazelnut',
        'pecan',
        'brazil nut',
        'macadamia',
        'pistachio'
      ],
      'milk': ['dairy', 'lactose', 'casein', 'whey'],
      'dairy': ['milk', 'lactose', 'casein', 'whey'],
      'eggs': ['egg', 'albumin'],
      'egg': ['eggs', 'albumin'],
      'wheat': ['gluten', 'flour'],
      'gluten': ['wheat', 'barley', 'rye', 'oats'],
      'soy': ['soya', 'soybean', 'soybeans'],
      'soya': ['soy', 'soybean', 'soybeans'],
      'fish': ['seafood', 'salmon', 'tuna', 'cod', 'mackerel'],
      'shellfish': ['crustacean', 'shrimp', 'crab', 'lobster', 'mollusc'],
      'sesame': ['sesame seed', 'tahini'],
      'palm oil': ['palm', 'palm fat', 'palm kernel oil', 'palm kernel fat'],
      'palm': ['palm oil', 'palm fat', 'palm kernel oil', 'palm kernel fat'],
      'sunflower oil': ['sunflower', 'sunflower seed oil'],
      'sunflower': ['sunflower oil', 'sunflower seed oil'],
      'vegetable oil': [
        'palm',
        'sunflower',
        'soybean oil',
        'canola oil',
        'rapeseed oil'
      ],
      'coconut oil': ['coconut', 'coconut fat'],
      'coconut': ['coconut oil', 'coconut fat'],
    };

    // Check if restriction matches any variations in ingredient
    if (allergenMap.containsKey(cleanRestriction)) {
      for (final variation in allergenMap[cleanRestriction]!) {
        if (cleanIngredient.contains(variation)) {
          return true;
        }
      }
    }

    // Check if ingredient matches any variations in restriction
    if (allergenMap.containsKey(cleanIngredient)) {
      for (final variation in allergenMap[cleanIngredient]!) {
        if (cleanRestriction.contains(variation)) {
          return true;
        }
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
  static const String _oldApiUrl = 'https://world.openfoodfacts.org/api/v0';

  // Cache properties
  static Map<String, List<String>>? _cachedAllergensByCategory;
  static Map<String, List<String>>? _cachedIngredientsByCategory;
  static DateTime? _allergensLastFetched;
  static DateTime? _ingredientsLastFetched;
  static const Duration _cacheValidity = Duration(days: 7);

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

  Future<List<String>> getAllAllergens() async {
    final allergensByCategory = await getAllAllergensByCategory();
    final allAllergens = <String>[];

    for (final allergens in allergensByCategory.values) {
      allAllergens.addAll(allergens);
    }

    allAllergens.sort();
    return allAllergens;
  }

  Future<Map<String, List<String>>> getAllAllergensByCategory() async {
    // Check if we have a valid cache
    if (_cachedAllergensByCategory != null &&
        _allergensLastFetched != null &&
        DateTime.now().difference(_allergensLastFetched!) < _cacheValidity) {
      return _cachedAllergensByCategory!;
    }

    try {
      // First, try to get the allergens from the taxonomy API
      final response = await http.get(
        Uri.parse('$_oldApiUrl/allergens.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['tags'] != null) {
          // Create categorized allergens
          final Map<String, List<String>> allergensByCategory = {
            'Common Allergens': [],
            'Cereals': [],
            'Nuts & Seeds': [],
            'Dairy': [],
            'Animal Products': [],
            'Fruits': [],
            'Vegetables': [],
            'Other': [],
          };

          // Extract allergen names from the taxonomy and categorize them
          for (final tag in data['tags']) {
            final name = tag['name'] ?? tag['id'];
            if (name == null) continue;

            final allergenName = name.toString();
            final lowerName = allergenName.toLowerCase();

            if (lowerName.contains('gluten') ||
                lowerName.contains('wheat') ||
                lowerName.contains('barley') ||
                lowerName.contains('rye') ||
                lowerName.contains('oat')) {
              allergensByCategory['Cereals']!.add(allergenName);
            } else if (lowerName.contains('nut') ||
                lowerName.contains('seed') ||
                lowerName.contains('sesame') ||
                lowerName.contains('mustard')) {
              allergensByCategory['Nuts & Seeds']!.add(allergenName);
            } else if (lowerName.contains('milk') ||
                lowerName.contains('dairy') ||
                lowerName.contains('lactose') ||
                lowerName.contains('cheese') ||
                lowerName.contains('butter')) {
              allergensByCategory['Dairy']!.add(allergenName);
            } else if (lowerName.contains('egg') ||
                lowerName.contains('fish') ||
                lowerName.contains('shellfish') ||
                lowerName.contains('crustacean') ||
                lowerName.contains('mollusc')) {
              allergensByCategory['Animal Products']!.add(allergenName);
            } else if (lowerName.contains('fruit') ||
                lowerName.contains('citrus') ||
                lowerName.contains('berry') ||
                lowerName.contains('apple') ||
                lowerName.contains('banana')) {
              allergensByCategory['Fruits']!.add(allergenName);
            } else if (lowerName.contains('vegetable') ||
                lowerName.contains('celery') ||
                lowerName.contains('garlic') ||
                lowerName.contains('onion')) {
              allergensByCategory['Vegetables']!.add(allergenName);
            } else {
              // Check if it's a common allergen
              if (lowerName.contains('peanut') ||
                  lowerName.contains('soy') ||
                  lowerName.contains('lupin') ||
                  lowerName.contains('sulphite') ||
                  lowerName.contains('sulfite')) {
                allergensByCategory['Common Allergens']!.add(allergenName);
              } else {
                allergensByCategory['Other']!.add(allergenName);
              }
            }
          }

          // Sort each category
          for (final category in allergensByCategory.keys) {
            allergensByCategory[category]!.sort();
          }

          // Remove empty categories
          allergensByCategory.removeWhere((key, value) => value.isEmpty);

          // Update cache
          _cachedAllergensByCategory = allergensByCategory;
          _allergensLastFetched = DateTime.now();

          return allergensByCategory;
        }
      }

      // Use cache if available, even if expired
      if (_cachedAllergensByCategory != null) {
        return _cachedAllergensByCategory!;
      }

      // Fallback to a comprehensive list if API fails
      final fallbackMap = _getFallbackAllergensByCategory();
      _cachedAllergensByCategory = fallbackMap;
      _allergensLastFetched = DateTime.now();
      return fallbackMap;
    } catch (e) {
      print('Error fetching allergens: $e');

      // Use cache if available, even if expired
      if (_cachedAllergensByCategory != null) {
        return _cachedAllergensByCategory!;
      }

      final fallbackMap = _getFallbackAllergensByCategory();
      _cachedAllergensByCategory = fallbackMap;
      _allergensLastFetched = DateTime.now();
      return fallbackMap;
    }
  }

  Future<List<String>> getAllIngredients() async {
    final ingredientsByCategory = await getAllIngredientsByCategory();
    final allIngredients = <String>[];

    for (final ingredients in ingredientsByCategory.values) {
      allIngredients.addAll(ingredients);
    }

    allIngredients.sort();
    return allIngredients;
  }

  Future<Map<String, List<String>>> getAllIngredientsByCategory() async {
    // Check if we have a valid cache
    if (_cachedIngredientsByCategory != null &&
        _ingredientsLastFetched != null &&
        DateTime.now().difference(_ingredientsLastFetched!) < _cacheValidity) {
      return _cachedIngredientsByCategory!;
    }

    try {
      // Try to get the ingredients from the taxonomy API
      final response = await http.get(
        Uri.parse('$_oldApiUrl/ingredients.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['tags'] != null) {
          // Create categorized ingredients
          final Map<String, List<String>> ingredientsByCategory = {
            'Cereals & Grains': [],
            'Dairy': [],
            'Fruits': [],
            'Vegetables': [],
            'Meats': [],
            'Seafood': [],
            'Nuts & Seeds': [],
            'Oils & Fats': [],
            'Sweeteners': [],
            'Spices & Herbs': [],
            'Additives': [],
            'Other': [],
          };

          // Extract ingredient names from the taxonomy and categorize them
          int count = 0;
          for (final tag in data['tags']) {
            if (count >= 1000) break; // Limit to 1000 ingredients

            final name = tag['name'] ?? tag['id'];
            if (name == null) continue;

            final ingredientName = name.toString();
            final lowerName = ingredientName.toLowerCase();

            if (lowerName.contains('flour') ||
                lowerName.contains('wheat') ||
                lowerName.contains('rice') ||
                lowerName.contains('corn') ||
                lowerName.contains('oat') ||
                lowerName.contains('barley') ||
                lowerName.contains('grain')) {
              ingredientsByCategory['Cereals & Grains']!.add(ingredientName);
            } else if (lowerName.contains('milk') ||
                lowerName.contains('cheese') ||
                lowerName.contains('yogurt') ||
                lowerName.contains('cream') ||
                lowerName.contains('butter')) {
              ingredientsByCategory['Dairy']!.add(ingredientName);
            } else if (lowerName.contains('fruit') ||
                lowerName.contains('apple') ||
                lowerName.contains('banana') ||
                lowerName.contains('berry') ||
                lowerName.contains('citrus')) {
              ingredientsByCategory['Fruits']!.add(ingredientName);
            } else if (lowerName.contains('vegetable') ||
                lowerName.contains('carrot') ||
                lowerName.contains('potato') ||
                lowerName.contains('onion') ||
                lowerName.contains('garlic') ||
                lowerName.contains('tomato')) {
              ingredientsByCategory['Vegetables']!.add(ingredientName);
            } else if (lowerName.contains('meat') ||
                lowerName.contains('beef') ||
                lowerName.contains('pork') ||
                lowerName.contains('chicken') ||
                lowerName.contains('turkey')) {
              ingredientsByCategory['Meats']!.add(ingredientName);
            } else if (lowerName.contains('fish') ||
                lowerName.contains('seafood') ||
                lowerName.contains('shrimp') ||
                lowerName.contains('crab') ||
                lowerName.contains('lobster')) {
              ingredientsByCategory['Seafood']!.add(ingredientName);
            } else if (lowerName.contains('nut') ||
                lowerName.contains('seed') ||
                lowerName.contains('almond') ||
                lowerName.contains('cashew') ||
                lowerName.contains('peanut')) {
              ingredientsByCategory['Nuts & Seeds']!.add(ingredientName);
            } else if (lowerName.contains('oil') ||
                lowerName.contains('fat') ||
                lowerName.contains('margarine')) {
              ingredientsByCategory['Oils & Fats']!.add(ingredientName);
            } else if (lowerName.contains('sugar') ||
                lowerName.contains('sweetener') ||
                lowerName.contains('honey') ||
                lowerName.contains('syrup')) {
              ingredientsByCategory['Sweeteners']!.add(ingredientName);
            } else if (lowerName.contains('spice') ||
                lowerName.contains('herb') ||
                lowerName.contains('pepper') ||
                lowerName.contains('salt')) {
              ingredientsByCategory['Spices & Herbs']!.add(ingredientName);
            } else if (lowerName.contains('additive') ||
                lowerName.contains('e-') ||
                lowerName.contains('preservative') ||
                lowerName.contains('coloring') ||
                lowerName.contains('flavoring')) {
              ingredientsByCategory['Additives']!.add(ingredientName);
            } else {
              ingredientsByCategory['Other']!.add(ingredientName);
            }

            count++;
          }

          // Sort each category
          for (final category in ingredientsByCategory.keys) {
            ingredientsByCategory[category]!.sort();
          }

          // Remove empty categories
          ingredientsByCategory.removeWhere((key, value) => value.isEmpty);

          // Update cache
          _cachedIngredientsByCategory = ingredientsByCategory;
          _ingredientsLastFetched = DateTime.now();

          return ingredientsByCategory;
        }
      }

      // Use cache if available, even if expired
      if (_cachedIngredientsByCategory != null) {
        return _cachedIngredientsByCategory!;
      }

      // If API fails, return a smaller list of common ingredients
      final commonMap = _getCommonIngredientsByCategory();
      _cachedIngredientsByCategory = commonMap;
      _ingredientsLastFetched = DateTime.now();
      return commonMap;
    } catch (e) {
      print('Error fetching ingredients: $e');

      // Use cache if available, even if expired
      if (_cachedIngredientsByCategory != null) {
        return _cachedIngredientsByCategory!;
      }

      final commonMap = _getCommonIngredientsByCategory();
      _cachedIngredientsByCategory = commonMap;
      _ingredientsLastFetched = DateTime.now();
      return commonMap;
    }
  }

  Future<List<String>> searchIngredients(String query) async {
    if (query.length < 2) return [];

    try {
      final response = await http.get(
        Uri.parse(
            '$_oldApiUrl/ingredients/search/${Uri.encodeComponent(query)}.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['tags'] != null) {
          final ingredients = (data['tags'] as List)
              .take(50) // Limit results
              .map((tag) => tag['name'] ?? tag['id'])
              .where((name) => name != null)
              .map((name) => name.toString())
              .toList();

          return ingredients;
        }
      }

      // If API fails, search in local cache
      final allIngredients = await getAllIngredients();
      return allIngredients
          .where((ingredient) =>
              ingredient.toLowerCase().contains(query.toLowerCase()))
          .take(50)
          .toList();
    } catch (e) {
      print('Error searching ingredients: $e');

      // Search in local cache as fallback
      final allIngredients = await getAllIngredients();
      return allIngredients
          .where((ingredient) =>
              ingredient.toLowerCase().contains(query.toLowerCase()))
          .take(50)
          .toList();
    }
  }

  Map<String, List<String>> _getFallbackAllergensByCategory() {
    return {
      'Common Allergens': [
        'Peanuts',
        'Soybeans',
        'Lupin',
        'Sulphur dioxide and sulphites',
      ],
      'Cereals': [
        'Cereals containing gluten',
        'Wheat',
        'Rye',
        'Barley',
        'Oats',
        'Spelt',
        'Khorasan wheat',
      ],
      'Nuts & Seeds': [
        'Tree Nuts',
        'Almonds',
        'Hazelnuts',
        'Walnuts',
        'Cashews',
        'Pecan nuts',
        'Brazil nuts',
        'Pistachio nuts',
        'Macadamia nuts',
        'Sesame seeds',
        'Mustard',
      ],
      'Dairy': [
        'Milk',
        'Lactose',
        'Dairy',
      ],
      'Animal Products': [
        'Eggs',
        'Fish',
        'Crustaceans',
        'Molluscs',
        'Shellfish',
      ],
    };
  }

  Map<String, List<String>> _getCommonIngredientsByCategory() {
    return {
      'Cereals & Grains': [
        'Wheat flour',
        'Rice',
        'Corn',
        'Oats',
        'Barley',
        'Rye',
        'Flour',
        'Rice flour',
        'Corn flour',
        'Potato starch',
        'Corn starch',
        'Tapioca starch',
      ],
      'Dairy': [
        'Milk',
        'Cream',
        'Yogurt',
        'Cheese',
        'Butter',
        'Lactose',
      ],
      'Fruits': [
        'Apples',
        'Bananas',
        'Oranges',
        'Grapes',
        'Strawberries',
        'Blueberries',
        'Raspberries',
      ],
      'Vegetables': [
        'Tomatoes',
        'Potatoes',
        'Onions',
        'Garlic',
        'Carrots',
        'Celery',
        'Lettuce',
        'Spinach',
      ],
      'Meats': [
        'Beef',
        'Pork',
        'Chicken',
        'Turkey',
      ],
      'Seafood': [
        'Fish',
        'Salmon',
        'Tuna',
        'Cod',
        'Shrimp',
        'Crab',
        'Lobster',
      ],
      'Nuts & Seeds': [
        'Peanuts',
        'Almonds',
        'Walnuts',
        'Cashews',
        'Hazelnuts',
        'Pecans',
        'Pistachios',
        'Sesame seeds',
      ],
      'Oils & Fats': [
        'Vegetable oil',
        'Olive oil',
        'Sunflower oil',
        'Palm oil',
        'Coconut oil',
        'Canola oil',
        'Soybean oil',
        'Butter',
        'Margarine',
      ],
      'Sweeteners': [
        'Sugar',
        'Glucose',
        'Fructose',
        'Sucrose',
        'Honey',
        'Maple syrup',
        'Molasses',
        'Artificial sweetener',
        'Aspartame',
        'Sucralose',
        'Stevia',
        'Xylitol',
        'Sorbitol',
        'Maltitol',
      ],
      'Spices & Herbs': [
        'Salt',
        'Pepper',
        'Cinnamon',
        'Cumin',
        'Oregano',
        'Basil',
        'Thyme',
        'Rosemary',
      ],
      'Additives': [
        'Monosodium glutamate (MSG)',
        'Citric acid',
        'Lactic acid',
        'Ascorbic acid (Vitamin C)',
        'Tocopherol (Vitamin E)',
        'Lecithin',
        'Pectin',
        'Gelatin',
        'Carrageenan',
        'Xanthan gum',
        'Guar gum',
        'Locust bean gum',
        'Food coloring',
        'Natural flavors',
        'Artificial flavors',
        'Preservatives',
        'Antioxidants',
        'Emulsifiers',
        'Stabilizers',
        'Thickeners',
        'Acidity regulators',
      ],
      'Other': [
        'Water',
        'Yeast',
        'Baking powder',
        'Baking soda',
        'Vinegar',
        'Lemon juice',
        'Chocolate',
        'Cocoa',
        'Vanilla',
        'Soy',
        'Soybeans',
        'Tofu',
        'Eggs',
        'Egg white',
        'Egg yolk',
      ],
    };
  }
}
