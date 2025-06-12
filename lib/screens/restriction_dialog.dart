import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/profile.dart';

Future<Restriction?> showRestrictionDialog({
  required BuildContext context,
  required List<Restriction> existingRestrictions,
}) async {
  return showDialog<Restriction>(
    context: context,
    builder: (context) => RestrictionDialog(
      existingRestrictions: existingRestrictions,
    ),
  );
}

Future<Restriction?> showEditRestrictionDialog({
  required BuildContext context,
  required Restriction restriction,
}) async {
  return showDialog<Restriction>(
    context: context,
    builder: (context) => RestrictionDialog(
      restriction: restriction,
      existingRestrictions: const [],
    ),
  );
}

class RestrictionDialog extends StatefulWidget {
  final Restriction? restriction;
  final List<Restriction> existingRestrictions;

  const RestrictionDialog({
    super.key,
    this.restriction,
    required this.existingRestrictions,
  });

  @override
  State<RestrictionDialog> createState() => _RestrictionDialogState();
}

class _RestrictionDialogState extends State<RestrictionDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  RestrictionCategory _selectedCategory = RestrictionCategory.allergen;
  RestrictionSeverity _selectedSeverity = RestrictionSeverity.medium;

  List<String> _searchResults = [];
  bool _isSearching = false;

  // Common allergens
  final List<String> _commonAllergens = [
    'Milk',
    'Eggs',
    'Fish',
    'Shellfish',
    'Tree nuts',
    'Peanuts',
    'Wheat',
    'Soybeans',
    'Sesame',
    'Mustard',
    'Celery',
    'Lupin',
    'Molluscs',
    'Sulphites',
  ];

  // Common ingredients
  final List<String> _commonIngredients = [
    'Gluten',
    'Lactose',
    'Casein',
    'Whey',
    'Gelatin',
    'Carmine',
    'Lecithin',
    'Monosodium glutamate',
    'Artificial colors',
    'Artificial flavors',
    'Preservatives',
    'High fructose corn syrup',
    'Palm oil',
    'Trans fats',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    if (widget.restriction != null) {
      _nameController.text = widget.restriction!.name;
      _selectedCategory = widget.restriction!.category;
      _selectedSeverity = widget.restriction!.severity;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final results = [
          ..._commonAllergens,
          ..._commonIngredients,
        ]
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  void _selectIngredient(String ingredient) {
    _nameController.text = ingredient;
    _tabController.animateTo(0); // Switch to first tab
  }

  bool _isItemAlreadyRestricted(String name) {
    return widget.existingRestrictions
        .any((r) => r.name.toLowerCase() == name.toLowerCase());
  }

  void _saveRestriction() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (widget.restriction == null && _isItemAlreadyRestricted(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.itemAlreadyInRestrictions),
        ),
      );
      return;
    }

    final restriction = Restriction(
      id: widget.restriction?.id,
      name: name,
      category: _selectedCategory,
      severity: _selectedSeverity,
    );

    Navigator.of(context).pop(restriction);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.restriction != null;

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditing ? l10n.editRestriction : l10n.addFoodRestriction,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Tab bar
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: l10n.commonAllergens),
                Tab(text: l10n.allIngredients),
                Tab(text: l10n.search),
              ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Common allergens tab
                  _buildAllergensTab(),

                  // All ingredients tab
                  _buildIngredientsTab(),

                  // Search tab
                  _buildSearchTab(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Name input
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.ingredientName,
                hintText: l10n.enterIngredientName,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Category and severity
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<RestrictionCategory>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: l10n.category,
                      border: const OutlineInputBorder(),
                    ),
                    items: RestrictionCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.getDisplayName(context)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<RestrictionSeverity>(
                    value: _selectedSeverity,
                    decoration: InputDecoration(
                      labelText: l10n.severity,
                      border: const OutlineInputBorder(),
                    ),
                    items: RestrictionSeverity.values.map((severity) {
                      return DropdownMenuItem(
                        value: severity,
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: severity.color, size: 16),
                            const SizedBox(width: 8),
                            Text(severity.getDisplayName(context)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSeverity = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: _nameController.text.trim().isNotEmpty
                      ? _saveRestriction
                      : null,
                  child: Text(isEditing ? l10n.save : l10n.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergensTab() {
    return ListView.builder(
      itemCount: _commonAllergens.length,
      itemBuilder: (context, index) {
        final allergen = _commonAllergens[index];
        final isRestricted = _isItemAlreadyRestricted(allergen);

        return ListTile(
          title: Text(allergen),
          trailing: isRestricted
              ? const Icon(Icons.check, color: Colors.green)
              : const Icon(Icons.add),
          enabled: !isRestricted,
          onTap: isRestricted ? null : () => _selectIngredient(allergen),
        );
      },
    );
  }

  Widget _buildIngredientsTab() {
    return ListView.builder(
      itemCount: _commonIngredients.length,
      itemBuilder: (context, index) {
        final ingredient = _commonIngredients[index];
        final isRestricted = _isItemAlreadyRestricted(ingredient);

        return ListTile(
          title: Text(ingredient),
          trailing: isRestricted
              ? const Icon(Icons.check, color: Colors.green)
              : const Icon(Icons.add),
          enabled: !isRestricted,
          onTap: isRestricted ? null : () => _selectIngredient(ingredient),
        );
      },
    );
  }

  Widget _buildSearchTab() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: l10n.searchIngredients,
            hintText: l10n.typeToSearch,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.search),
          ),
          onChanged: _performSearch,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _buildSearchResults(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final l10n = AppLocalizations.of(context)!;

    if (_searchController.text.length < 2) {
      return Center(
        child: Text(l10n.typeAtLeastTwoChars),
      );
    }

    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(l10n.noResultsFound),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final isRestricted = _isItemAlreadyRestricted(result);

        return ListTile(
          title: Text(result),
          trailing: isRestricted
              ? const Icon(Icons.check, color: Colors.green)
              : const Icon(Icons.add),
          enabled: !isRestricted,
          onTap: isRestricted ? null : () => _selectIngredient(result),
        );
      },
    );
  }
}
