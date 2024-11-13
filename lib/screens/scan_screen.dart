import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/product_service.dart';
import '../services/profile_service.dart';
import '../models/profile.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController controller = MobileScannerController();
  final ProductService _productService = ProductService();
  late Future<ProfileService> _profileServiceFuture;
  bool _isScanning = true;
  String? _lastCode;
  bool _isLoading = false;
  Profile? _activeProfile;

  @override
  void initState() {
    super.initState();
    _profileServiceFuture = ProfileService.create();
    _loadActiveProfile();
  }

  Future<void> _loadActiveProfile() async {
    final service = await _profileServiceFuture;
    final profile = await service.getActiveProfile();
    setState(() {
      _activeProfile = profile;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showManualEntryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter EAN Code'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'EAN Code',
            hintText: 'Enter product EAN code',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final code = controller.text.trim();
              if (code.isNotEmpty) {
                Navigator.pop(context);
                _processBarcode(code);
              }
            },
            child: const Text('Check'),
          ),
        ],
      ),
    );
  }

  Future<void> _processBarcode(String barcode) async {
    setState(() {
      _lastCode = barcode;
      _isScanning = false;
      _isLoading = true;
    });

    try {
      final product = await _productService.getProductByBarcode(barcode);

      if (!mounted) return;

      if (product != null) {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, controller) => ProductDetailsSheet(
              product: product,
              activeProfile: _activeProfile,
              scrollController: controller,
              onScanAgain: () {
                Navigator.pop(context);
                setState(() {
                  _isScanning = true;
                  _isLoading = false;
                });
              },
            ),
          ),
        ).then((_) {
          // Reset state after bottom sheet is closed
          setState(() {
            _isScanning = true;
            _isLoading = false;
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product not found'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue == null) continue;
      await _processBarcode(barcode.rawValue!);
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off);
                  case TorchState.on:
                    return const Icon(Icons.flash_on);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_activeProfile == null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange[100],
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No active profile selected. Product restrictions won\'t be checked.',
                      style: TextStyle(color: Colors.orange[900]),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isScanning
                    ? Stack(
                        children: [
                          MobileScanner(
                            controller: controller,
                            onDetect: _onDetect,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              color: Colors.black87,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.qr_code_scanner,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Point camera at product barcode',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton.icon(
                                    onPressed: _showManualEntryDialog,
                                    icon: const Icon(
                                      Icons.keyboard,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Enter EAN manually',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Last scanned code:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              _lastCode ?? 'None',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() => _isScanning = true);
                              },
                              child: const Text('Scan Again'),
                            ),
                            TextButton(
                              onPressed: _showManualEntryDialog,
                              child: const Text('Enter EAN manually'),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsSheet extends StatelessWidget {
  final Product product;
  final Profile? activeProfile;
  final ScrollController scrollController;
  final VoidCallback onScanAgain;

  const ProductDetailsSheet({
    super.key,
    required this.product,
    required this.activeProfile,
    required this.scrollController,
    required this.onScanAgain,
  });

  List<String> _checkRestrictions() {
    if (activeProfile == null) return [];

    final restrictionNames =
        activeProfile!.restrictions.map((r) => r.name.toLowerCase()).toList();

    return product.getMatchingRestrictions(restrictionNames);
  }

  @override
  Widget build(BuildContext context) {
    final restrictedIngredients = _checkRestrictions();
    final hasRestrictions = restrictedIngredients.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView(
        controller: scrollController,
        children: [
          if (activeProfile != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: hasRestrictions ? Colors.red[100] : Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    hasRestrictions ? Icons.warning : Icons.check_circle,
                    color: hasRestrictions ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasRestrictions
                          ? 'Contains restricted ingredients: ${restrictedIngredients.join(", ")}'
                          : 'No restricted ingredients found',
                      style: TextStyle(
                        color: hasRestrictions
                            ? Colors.red[900]
                            : Colors.green[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          if (product.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.imageUrl!,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: Icon(Icons.image_not_supported),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            product.brand,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          if (product.nutriScore != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Nutri-Score: '),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getNutriScoreColor(product.nutriScore!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.nutriScore!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(product.ingredients.join(', ')),
          if (product.allergens.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Allergens',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.allergens.map((allergen) {
                return Chip(
                  label: Text(allergen),
                  backgroundColor: Colors.red[100],
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'Nutritional Values (per 100g)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildNutritionTable(context),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onScanAgain,
            child: const Text('Scan Another Product'),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionTable(BuildContext context) {
    final nutrientsList = [
      'energy',
      'fat',
      'saturated-fat',
      'carbohydrates',
      'sugars',
      'proteins',
      'salt',
      'fiber',
    ];

    return Table(
      border: TableBorder.all(
        color: Colors.grey[300]!,
        width: 1,
      ),
      children: [
        const TableRow(
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Nutrient',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Value',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        ...nutrientsList.map((nutrient) {
          final value =
              ProductService().getNutrientValue(product.nutriments, nutrient);
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  ProductService().formatNutrientName(nutrient),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(value),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Color _getNutriScoreColor(String score) {
    switch (score.toUpperCase()) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.yellow;
      case 'D':
        return Colors.orange;
      case 'E':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
