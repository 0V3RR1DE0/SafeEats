import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/product_service.dart';

class ScanHistoryItem {
  final String barcode;
  final String productName;
  final String brand;
  final DateTime scannedAt;
  final bool hadRestrictions;
  final int restrictionCount;
  final String? imageUrl;

  ScanHistoryItem({
    required this.barcode,
    required this.productName,
    required this.brand,
    required this.scannedAt,
    required this.hadRestrictions,
    required this.restrictionCount,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'productName': productName,
      'brand': brand,
      'scannedAt': scannedAt.toIso8601String(),
      'hadRestrictions': hadRestrictions,
      'restrictionCount': restrictionCount,
      'imageUrl': imageUrl,
    };
  }

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) {
    return ScanHistoryItem(
      barcode: json['barcode'] ?? '',
      productName: json['productName'] ?? 'Unknown Product',
      brand: json['brand'] ?? 'Unknown Brand',
      scannedAt: DateTime.parse(json['scannedAt']),
      hadRestrictions: json['hadRestrictions'] ?? false,
      restrictionCount: json['restrictionCount'] ?? 0,
      imageUrl: json['imageUrl'],
    );
  }
}

class ScanHistoryService {
  static const String _historyKey = 'scan_history';
  static const int _maxHistoryItems = 50;

  Future<List<ScanHistoryItem>> getRecentScans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      final history = historyJson
          .map((jsonString) {
            try {
              final json = jsonDecode(jsonString) as Map<String, dynamic>;
              return ScanHistoryItem.fromJson(json);
            } catch (e) {
              return null;
            }
          })
          .where((item) => item != null)
          .cast<ScanHistoryItem>()
          .toList();

      // Sort by scan date (most recent first)
      history.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));

      return history;
    } catch (e) {
      print('Error loading scan history: $e');
      return [];
    }
  }

  Future<void> addScan(
      Product product, bool hadRestrictions, int restrictionCount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      // Create new scan item
      final scanItem = ScanHistoryItem(
        barcode: product.barcode,
        productName: product.name,
        brand: product.brand,
        scannedAt: DateTime.now(),
        hadRestrictions: hadRestrictions,
        restrictionCount: restrictionCount,
        imageUrl: product.imageUrl,
      );

      // Remove any existing scan of the same product (to avoid duplicates)
      historyJson.removeWhere((jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return json['barcode'] == product.barcode;
        } catch (e) {
          return false;
        }
      });

      // Add new scan at the beginning
      historyJson.insert(0, jsonEncode(scanItem.toJson()));

      // Keep only the most recent items
      if (historyJson.length > _maxHistoryItems) {
        historyJson.removeRange(_maxHistoryItems, historyJson.length);
      }

      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Error saving scan to history: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('Error clearing scan history: $e');
    }
  }

  Future<List<ScanHistoryItem>> getRecentScansLimited(int limit) async {
    final allScans = await getRecentScans();
    return allScans.take(limit).toList();
  }

  Future<bool> hasScannedProduct(String barcode) async {
    final history = await getRecentScans();
    return history.any((item) => item.barcode == barcode);
  }

  Future<ScanHistoryItem?> getLastScanOfProduct(String barcode) async {
    final history = await getRecentScans();
    try {
      return history.firstWhere((item) => item.barcode == barcode);
    } catch (e) {
      return null;
    }
  }
}
