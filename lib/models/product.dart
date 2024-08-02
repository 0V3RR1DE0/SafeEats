// lib/models/product.dart
class Product {
  final String name;
  final List<String> ingredients;

  Product({required this.name, required this.ingredients});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['product_name'] ?? 'Unknown',
      ingredients: List<String>.from(json['ingredients_text_en']?.split(',') ?? []),
    );
  }
}