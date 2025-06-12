import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';
import 'restriction_dialog.dart';

class RestrictionsScreen extends StatefulWidget {
  final Profile profile;
  final ProfileService profileService;

  const RestrictionsScreen({
    super.key,
    required this.profile,
    required this.profileService,
  });

  @override
  State<RestrictionsScreen> createState() => _RestrictionsScreenState();
}

class _RestrictionsScreenState extends State<RestrictionsScreen> {
  List<Restriction> _restrictions = [];

  @override
  void initState() {
    super.initState();
    _loadRestrictions();
  }

  Future<void> _loadRestrictions() async {
    setState(() {
      _restrictions = widget.profile.restrictions;
    });
  }

  Future<void> _addRestriction(String name, RestrictionCategory category,
      RestrictionSeverity severity) async {
    final restriction = Restriction(
      name: name,
      category: category,
      severity: severity,
    );

    final updatedProfile = widget.profile.copyWith(
      restrictions: [...widget.profile.restrictions, restriction],
    );

    await widget.profileService.updateProfile(updatedProfile);
    setState(() {
      _restrictions = updatedProfile.restrictions;
    });
  }

  Future<void> _updateRestriction(
      Restriction oldRestriction, Restriction newRestriction) async {
    final updatedRestrictions = widget.profile.restrictions.map((r) {
      if (r.id == oldRestriction.id) {
        return newRestriction;
      }
      return r;
    }).toList();

    final updatedProfile = widget.profile.copyWith(
      restrictions: updatedRestrictions,
    );

    await widget.profileService.updateProfile(updatedProfile);
    setState(() {
      _restrictions = updatedProfile.restrictions;
    });
  }

  Future<void> _deleteRestriction(Restriction restriction) async {
    final updatedRestrictions = widget.profile.restrictions
        .where((r) => r.id != restriction.id)
        .toList();

    final updatedProfile = widget.profile.copyWith(
      restrictions: updatedRestrictions,
    );

    await widget.profileService.updateProfile(updatedProfile);
    setState(() {
      _restrictions = updatedProfile.restrictions;
    });
  }

  void _showAddRestrictionDialog() async {
    final result = await showRestrictionDialog(
      context: context,
      existingRestrictions: _restrictions,
    );

    if (result != null) {
      await _addRestriction(
        result.name,
        result.category,
        result.severity,
      );
    }
  }

  void _showEditRestrictionDialog(Restriction restriction) async {
    final result = await showEditRestrictionDialog(
      context: context,
      restriction: restriction,
    );

    if (result != null) {
      await _updateRestriction(restriction, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Group restrictions by category
    final Map<RestrictionCategory, List<Restriction>> groupedRestrictions = {};
    for (final restriction in _restrictions) {
      if (!groupedRestrictions.containsKey(restriction.category)) {
        groupedRestrictions[restriction.category] = [];
      }
      groupedRestrictions[restriction.category]!.add(restriction);
    }

    // Sort categories
    final sortedCategories = groupedRestrictions.keys.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileRestrictions(widget.profile.name)),
      ),
      body: _restrictions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.list_alt,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noRestrictionsYet,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.addFoodItemsToRestrict),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _showAddRestrictionDialog,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addRestriction),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: sortedCategories.length,
              itemBuilder: (context, categoryIndex) {
                final category = sortedCategories[categoryIndex];
                final categoryRestrictions = groupedRestrictions[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        category.getDisplayName(context),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    ...categoryRestrictions.map((restriction) => Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Text(restriction.name),
                            subtitle: Text(
                                restriction.severity.getDisplayName(context)),
                            leading: Icon(
                              Icons.block,
                              color: restriction.severity.color,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showEditRestrictionDialog(restriction),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteRestriction(restriction),
                                ),
                              ],
                            ),
                            onTap: () =>
                                _showEditRestrictionDialog(restriction),
                          ),
                        )),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRestrictionDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
