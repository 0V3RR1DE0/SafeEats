import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/profile.dart';
import '../services/product_service.dart';

Future<Restriction?> showRestrictionDialog({
  required BuildContext context,
  required List<Restriction> existingRestrictions,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final productService = ProductService();
  final searchController = TextEditingController();
  List<String> searchResults = [];
  bool isSearching = false;
  RestrictionCategory selectedCategory = RestrictionCategory.allergen;
  RestrictionSeverity selectedSeverity = RestrictionSeverity.high;
  String? selectedItem;
  bool isItemInList = false;

  void checkIfItemExists(String value) {
    // Check if the item already exists in the profile's restrictions
    final exists = existingRestrictions.any(
      (r) => r.name.toLowerCase() == value.toLowerCase(),
    );

    if (exists != isItemInList) {
      isItemInList = exists;
    }
  }

  return showDialog<Restriction?>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => DefaultTabController(
        length: 3,
        child: AlertDialog(
          title: Text(l10n.addFoodRestriction),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: l10n.commonAllergens),
                    Tab(text: l10n.allIngredients),
                    Tab(text: l10n.search),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Tab 1: Common Allergens
                      FutureBuilder<Map<String, List<String>>>(
                        future: productService.getAllAllergensByCategory(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return Center(
                                child: Text(l10n.failedToLoadAllergens));
                          }

                          final allergensByCategory = snapshot.data!;
                          final categories = allergensByCategory.keys.toList();

                          return ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, categoryIndex) {
                              final category = categories[categoryIndex];
                              final allergens = allergensByCategory[category]!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      category,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  ...allergens.map((allergen) => ListTile(
                                        title: Text(allergen),
                                        selected: selectedItem == allergen,
                                        selectedTileColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        onTap: () {
                                          setState(() {
                                            selectedItem = allergen;
                                            checkIfItemExists(allergen);
                                          });
                                        },
                                        dense: true,
                                      )),
                                  const SizedBox(height: 8),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      // Tab 2: All Ingredients
                      FutureBuilder<Map<String, List<String>>>(
                        future: productService.getAllIngredientsByCategory(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return Center(
                                child: Text(l10n.failedToLoadIngredients));
                          }

                          final ingredientsByCategory = snapshot.data!;
                          final categories =
                              ingredientsByCategory.keys.toList();

                          return ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, categoryIndex) {
                              final category = categories[categoryIndex];
                              final ingredients =
                                  ingredientsByCategory[category]!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      category,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  ...ingredients.map((ingredient) => ListTile(
                                        title: Text(ingredient),
                                        selected: selectedItem == ingredient,
                                        selectedTileColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        onTap: () {
                                          setState(() {
                                            selectedItem = ingredient;
                                            checkIfItemExists(ingredient);
                                          });
                                        },
                                        dense: true,
                                      )),
                                  const SizedBox(height: 8),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      // Tab 3: Search
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                labelText: l10n.searchIngredients,
                                hintText: l10n.typeToSearch,
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            searchController.clear();
                                            searchResults = [];
                                            selectedItem = null;
                                            isItemInList = false;
                                          });
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: (value) async {
                                if (value.length >= 2) {
                                  setState(() {
                                    isSearching = true;
                                    selectedItem = value;
                                  });
                                  checkIfItemExists(value);
                                  final results = await productService
                                      .searchIngredients(value);
                                  setState(() {
                                    searchResults = results;
                                    isSearching = false;
                                  });
                                } else {
                                  setState(() {
                                    searchResults = [];
                                    selectedItem =
                                        value.isNotEmpty ? value : null;
                                    isItemInList = false;
                                  });
                                }
                              },
                            ),
                          ),
                          if (isItemInList)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                l10n.itemAlreadyInRestrictions,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Expanded(
                            child: isSearching
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : searchResults.isEmpty
                                    ? Center(
                                        child: Text(
                                          searchController.text.length < 2
                                              ? l10n.typeAtLeastTwoChars
                                              : l10n.noResultsFound,
                                        ),
                                      )
                                    : ListView.separated(
                                        itemCount: searchResults.length,
                                        separatorBuilder: (_, __) =>
                                            const Divider(height: 1),
                                        itemBuilder: (context, index) {
                                          final result = searchResults[index];
                                          return ListTile(
                                            title: Text(result),
                                            selected: selectedItem == result,
                                            selectedTileColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            onTap: () {
                                              setState(() {
                                                selectedItem = result;
                                                searchController.text = result;
                                                checkIfItemExists(result);
                                              });
                                            },
                                            dense: true,
                                          );
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Category and severity selection
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<RestrictionCategory>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          labelText: l10n.category,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        items: RestrictionCategory.values.map((category) {
                          return DropdownMenuItem<RestrictionCategory>(
                            value: category,
                            child: Text(category.getDisplayName(context)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedCategory = value;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<RestrictionSeverity>(
                        value: selectedSeverity,
                        decoration: InputDecoration(
                          labelText: l10n.severity,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        items: RestrictionSeverity.values.map((severity) {
                          return DropdownMenuItem<RestrictionSeverity>(
                            value: severity,
                            child: Text(severity.getDisplayName(context)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedSeverity = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: selectedItem != null && !isItemInList
                  ? () {
                      Navigator.pop(
                        context,
                        Restriction(
                          name: selectedItem!,
                          category: selectedCategory,
                          severity: selectedSeverity,
                        ),
                      );
                    }
                  : null,
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<Restriction?> showEditRestrictionDialog({
  required BuildContext context,
  required Restriction restriction,
}) async {
  final l10n = AppLocalizations.of(context)!;
  RestrictionCategory selectedCategory = restriction.category;
  RestrictionSeverity selectedSeverity = restriction.severity;

  return showDialog<Restriction?>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(l10n.editRestriction),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              restriction.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<RestrictionCategory>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: l10n.category,
                border: const OutlineInputBorder(),
              ),
              items: RestrictionCategory.values.map((category) {
                return DropdownMenuItem<RestrictionCategory>(
                  value: category,
                  child: Text(category.getDisplayName(context)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<RestrictionSeverity>(
              value: selectedSeverity,
              decoration: InputDecoration(
                labelText: l10n.severity,
                border: const OutlineInputBorder(),
              ),
              items: RestrictionSeverity.values.map((severity) {
                return DropdownMenuItem<RestrictionSeverity>(
                  value: severity,
                  child: Text(severity.getDisplayName(context)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedSeverity = value;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                restriction.copyWith(
                  category: selectedCategory,
                  severity: selectedSeverity,
                ),
              );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    ),
  );
}
