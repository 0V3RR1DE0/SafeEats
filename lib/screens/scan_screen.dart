// lib/screens/scan_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/barcode_scanner_service.dart';
import '../services/open_food_facts_api_service.dart';
import 'product_details_screen.dart';
import '../widgets/app_scaffold.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final BarcodeScannerService _scannerService = BarcodeScannerService();
  final OpenFoodFactsApiService _apiService = OpenFoodFactsApiService();
  final TextEditingController _manualBarcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _scannerService.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Scan Product',
      body: Column(
        children: [
          Expanded(
            child: _scannerService.cameraController.value.isInitialized
                ? CameraPreview(_scannerService.cameraController)
                : Center(child: CircularProgressIndicator()),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _manualBarcodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter barcode manually',
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _processBarcode,
                child: Text('Process'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanBarcode,
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> _scanBarcode() async {
    final result = await _scannerService.scanBarcode();
    if (result != null) {
      if (result.length > 5) {
        _processProductInfo(result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid barcode/product code detected. Please try again or enter manually.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No barcode or numbers detected. Try manual entry.')),
      );
    }
  }

  Future<void> _processBarcode() async {
    final barcode = _manualBarcodeController.text.trim();
    if (barcode.isNotEmpty) {
      _processProductInfo(barcode);
    }
  }

  Future<void> _processProductInfo(String barcode) async {
    try {
      final product = await _apiService.getProductInfo(barcode);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(product: product),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load product info')),
      );
    }
  }

  @override
  void dispose() {
    _scannerService.dispose();
    _manualBarcodeController.dispose();
    super.dispose();
  }
}