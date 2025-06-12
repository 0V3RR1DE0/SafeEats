import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/product_service.dart';
import '../services/profile_service.dart';
import '../services/scan_history_service.dart';
import '../models/profile.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.ean13, BarcodeFormat.ean8],
    detectionSpeed: DetectionSpeed.normal,
  );
  final ProductService _productService = ProductService();
  late Future<ProfileService> _profileServiceFuture;
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
    setState(() => _activeProfile = profile);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showManualEntryDialog() {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.enterEanCode),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.eanCode,
            hintText: l10n.enterEanDigits,
            prefixIcon: const Icon(Icons.confirmation_number),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final code = controller.text.trim();
              if (code.length >= 8) {
                Navigator.pop(context);
                _processBarcode(code);
              }
            },
            child: Text(l10n.verify),
          ),
        ],
      ),
    );
  }

  Future<void> _processBarcode(String barcode) async {
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
    });

    try {
      final product = await _productService.getProductByBarcode(barcode);
      if (!mounted) return;

      if (product != null) {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => ProductDetailsSheet(
            product: product,
            activeProfile: _activeProfile,
            onScanAgain: () => setState(() => _isLoading = false),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.productNotFound)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanProduct),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (_, state, __) => Icon(
                state == TorchState.off ? Icons.flash_off : Icons.flash_on,
              ),
            ),
            onPressed: controller.toggleTorch,
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.cameraFacingState,
              builder: (_, state, __) => Icon(
                state == CameraFacing.front
                    ? Icons.camera_front
                    : Icons.camera_rear,
              ),
            ),
            onPressed: controller.switchCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null && _isLoading == false) {
                  _processBarcode(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          if (_activeProfile == null)
            MaterialBanner(
              content: Text(l10n.noActiveProfile),
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/profiles'),
                  child: Text(l10n.setProfile),
                ),
              ],
            ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
              child: FilledButton.icon(
                icon: const Icon(Icons.keyboard),
                label: Text(l10n.manualEntry),
                onPressed: _showManualEntryDialog,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsSheet extends StatefulWidget {
  final Product product;
  final Profile? activeProfile;
  final VoidCallback onScanAgain;

  const ProductDetailsSheet({
    super.key,
    required this.product,
    required this.activeProfile,
    required this.onScanAgain,
  });

  @override
  State<ProductDetailsSheet> createState() => _ProductDetailsSheetState();
}

class _ProductDetailsSheetState extends State<ProductDetailsSheet> {
  final ScanHistoryService _scanHistoryService = ScanHistoryService();

  @override
  void initState() {
    super.initState();
    _saveScanToHistory();
  }

  Future<void> _saveScanToHistory() async {
    if (widget.activeProfile != null) {
      final matchingRestrictions = widget.activeProfile!.restrictions
          .where((restriction) =>
              widget.product.containsRestriction(restriction.name))
          .toList();

      await _scanHistoryService.addScan(
        widget.product,
        matchingRestrictions.isNotEmpty,
        matchingRestrictions.length,
      );
    } else {
      await _scanHistoryService.addScan(widget.product, false, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final productService = ProductService();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (_, controller) => SingleChildScrollView(
        controller: controller,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Product details header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.product.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.product.imageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.shade200,
                          child:
                              const Icon(Icons.image_not_supported, size: 40),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.no_food, size: 40),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          widget.product.brand,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text('${l10n.barcode}: ${widget.product.barcode}'),
                        if (widget.product.nutriScore != null)
                          Chip(
                            label: Text(
                                'Nutri-Score ${widget.product.nutriScore}'),
                            backgroundColor:
                                _getNutriScoreColor(widget.product.nutriScore!),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Safety check section
              if (widget.activeProfile != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.safetyCheck,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        _buildSafetyCheck(context),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Ingredients section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.ingredients,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      widget.product.ingredients.isEmpty
                          ? Text(l10n.noIngredientsInfo)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.product.ingredients
                                  .map((ingredient) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('• '),
                                            Expanded(child: Text(ingredient)),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Allergens section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.allergens,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      widget.product.allergens.isEmpty
                          ? Text(l10n.noAllergensInfo)
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: widget.product.allergens
                                  .map((allergen) => Chip(
                                        label: Text(allergen),
                                        backgroundColor: Colors.red.shade100,
                                      ))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nutrition section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nutritionFacts,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      widget.product.nutriments.isEmpty
                          ? Text(l10n.noNutritionInfo)
                          : _buildNutritionTable(context, productService),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Scan again button
              Center(
                child: FilledButton(
                  onPressed: widget.onScanAgain,
                  child: Text(l10n.scanAgain),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyCheck(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.activeProfile == null ||
        widget.activeProfile!.restrictions.isEmpty) {
      return Text(l10n.noActiveProfileWithRestrictions);
    }

    final matchingRestrictions = widget.activeProfile!.restrictions
        .where((restriction) =>
            widget.product.containsRestriction(restriction.name))
        .toList();

    if (matchingRestrictions.isEmpty) {
      return Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
          const SizedBox(width: 8),
          Text(
            l10n.noRestrictionsFound(widget.activeProfile!.name),
            style: const TextStyle(color: Colors.green),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning, color: Colors.red, size: 24),
            const SizedBox(width: 8),
            Text(
              l10n.containsRestrictedItems(matchingRestrictions.length),
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...matchingRestrictions.map((restriction) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.block,
                      color: restriction.severity.color, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${restriction.name} (${restriction.severity.getDisplayName(context)})',
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildNutritionTable(
      BuildContext context, ProductService productService) {
    final nutrientKeys = [
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
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
      },
      border: TableBorder.all(
        color: Colors.grey.shade300,
        width: 1,
      ),
      children: nutrientKeys
          .where((key) => widget.product.nutriments.containsKey('${key}_100g'))
          .map((key) => TableRow(
                decoration: BoxDecoration(
                  color: nutrientKeys.indexOf(key) % 2 == 0
                      ? Colors.grey.shade100
                      : Colors.white,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(productService.formatNutrientName(key)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      productService.getNutrientValue(
                          widget.product.nutriments, key),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }

  Color _getNutriScoreColor(String score) {
    switch (score.toUpperCase()) {
      case 'A':
        return Colors.green.shade400;
      case 'B':
        return Colors.lightGreen.shade400;
      case 'C':
        return Colors.yellow.shade400;
      case 'D':
        return Colors.orange.shade400;
      case 'E':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}
