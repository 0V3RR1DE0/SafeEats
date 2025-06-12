import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';
import 'restriction_dialog.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  late Future<ProfileService> _profileServiceFuture;
  List<Profile> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _profileServiceFuture = ProfileService.create();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      final service = await _profileServiceFuture;
      final profiles = await service.getProfiles();
      if (mounted) {
        setState(() {
          _profiles = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profiles: $e')),
        );
      }
    }
  }

  Future<void> _addProfile(String name) async {
    try {
      final service = await _profileServiceFuture;
      final profile = Profile(name: name);
      await service.addProfile(profile);
      await _loadProfiles();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile "$name" created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating profile: $e')),
        );
      }
    }
  }

  Future<void> _editProfile(Profile profile, String newName) async {
    try {
      final service = await _profileServiceFuture;
      final updatedProfile = profile.copyWith(name: newName);
      await service.updateProfile(updatedProfile);
      await _loadProfiles();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  Future<void> _deleteProfile(String profileId) async {
    try {
      final service = await _profileServiceFuture;
      await service.deleteProfile(profileId);
      await _loadProfiles();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting profile: $e')),
        );
      }
    }
  }

  Future<void> _toggleActive(Profile profile) async {
    try {
      final service = await _profileServiceFuture;

      if (profile.isActive) {
        // Deactivate this profile
        final updatedProfile = profile.copyWith(isActive: false);
        await service.updateProfile(updatedProfile);
      } else {
        // Activate this profile (and deactivate others)
        await service.setActiveProfile(profile.id);
      }

      await _loadProfiles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile status: $e')),
        );
      }
    }
  }

  Future<void> _manageRestrictions(Profile profile) async {
    final service = await _profileServiceFuture;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestrictionsScreen(
          profile: profile,
          profileService: service,
        ),
      ),
    );
    await _loadProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profiles),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profiles.isEmpty
              ? _buildEmptyState(context, l10n, theme)
              : _buildProfilesList(context, l10n, theme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProfileDialog(context, l10n),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noProfilesYet,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addProfileToStart,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _showAddProfileDialog(context, l10n),
              icon: const Icon(Icons.add),
              label: Text(l10n.addProfile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilesList(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _profiles.length,
      itemBuilder: (context, index) {
        final profile = _profiles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: profile.isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      foregroundColor: profile.isActive
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      child: Text(
                        profile.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                profile.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (profile.isActive) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    l10n.active,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.restrictionsCount(profile.restrictions.length),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        switch (value) {
                          case 'activate':
                            await _toggleActive(profile);
                            break;
                          case 'edit':
                            await _showEditProfileDialog(
                                context, l10n, profile);
                            break;
                          case 'restrictions':
                            await _manageRestrictions(profile);
                            break;
                          case 'delete':
                            await _showDeleteConfirmation(
                                context, l10n, profile);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'activate',
                          child: Row(
                            children: [
                              Icon(
                                profile.isActive
                                    ? Icons.toggle_on
                                    : Icons.toggle_off,
                                color: profile.isActive
                                    ? theme.colorScheme.primary
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(profile.isActive
                                  ? l10n.deactivate
                                  : l10n.activate),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit),
                              const SizedBox(width: 8),
                              Text(l10n.editProfile),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'restrictions',
                          child: Row(
                            children: [
                              const Icon(Icons.list),
                              const SizedBox(width: 8),
                              Text('Manage Restrictions'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete,
                                  color: theme.colorScheme.error),
                              const SizedBox(width: 8),
                              Text(
                                l10n.deleteProfile,
                                style:
                                    TextStyle(color: theme.colorScheme.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (profile.restrictions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: profile.restrictions.take(3).map((restriction) {
                      return Chip(
                        label: Text(
                          restriction.name,
                          style: theme.textTheme.labelSmall,
                        ),
                        backgroundColor:
                            restriction.severity.color.withOpacity(0.1),
                        side: BorderSide(color: restriction.severity.color),
                      );
                    }).toList()
                      ..addAll(profile.restrictions.length > 3
                          ? [
                              Chip(
                                label: Text(
                                  '+${profile.restrictions.length - 3} more',
                                  style: theme.textTheme.labelSmall,
                                ),
                                backgroundColor:
                                    theme.colorScheme.surfaceVariant,
                              )
                            ]
                          : []),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddProfileDialog(
      BuildContext context, AppLocalizations l10n) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addProfile),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.profileName,
              hintText: l10n.enterProfileName,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a profile name';
              }
              if (_profiles.any(
                  (p) => p.name.toLowerCase() == value.trim().toLowerCase())) {
                return 'A profile with this name already exists';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );

    if (result != null) {
      await _addProfile(result);
    }
  }

  Future<void> _showEditProfileDialog(
    BuildContext context,
    AppLocalizations l10n,
    Profile profile,
  ) async {
    final controller = TextEditingController(text: profile.name);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editProfile),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.profileName,
              hintText: l10n.enterProfileName,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a profile name';
              }
              if (value.trim() != profile.name &&
                  _profiles.any((p) =>
                      p.name.toLowerCase() == value.trim().toLowerCase())) {
                return 'A profile with this name already exists';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result != null) {
      await _editProfile(profile, result);
    }
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    AppLocalizations l10n,
    Profile profile,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProfile),
        content: Text(l10n.deleteProfileConfirmation(profile.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deleteProfile(profile.id);
    }
  }
}

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
  late List<Restriction> _restrictions;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _restrictions = List.from(widget.profile.restrictions);
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedProfile = widget.profile.copyWith(
        restrictions: _restrictions,
      );
      await widget.profileService.updateProfile(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restrictions updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating restrictions: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addRestriction() async {
    final restriction = await showRestrictionDialog(
      context: context,
      existingRestrictions: _restrictions,
    );

    if (restriction != null) {
      setState(() {
        _restrictions.add(restriction);
      });
      await _saveProfile();
    }
  }

  Future<void> _editRestriction(Restriction restriction) async {
    final updatedRestriction = await showEditRestrictionDialog(
      context: context,
      restriction: restriction,
    );

    if (updatedRestriction != null) {
      setState(() {
        final index = _restrictions.indexWhere((r) => r.id == restriction.id);
        if (index != -1) {
          _restrictions[index] = updatedRestriction;
        }
      });
      await _saveProfile();
    }
  }

  Future<void> _deleteRestriction(Restriction restriction) async {
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Restriction'),
        content: Text(
            'Are you sure you want to remove "${restriction.name}" from restrictions?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        _restrictions.removeWhere((r) => r.id == restriction.id);
      });
      await _saveProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileRestrictions(widget.profile.name)),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _restrictions.isEmpty
              ? _buildEmptyState(context, l10n, theme)
              : _buildRestrictionsList(context, l10n, theme),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRestriction,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 80,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noRestrictionsYet,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addFoodItemsToRestrict,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _addRestriction,
              icon: const Icon(Icons.add),
              label: Text(l10n.addRestriction),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestrictionsList(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _restrictions.length,
      itemBuilder: (context, index) {
        final restriction = _restrictions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: restriction.severity.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: restriction.severity.color),
              ),
              child: Icon(
                Icons.block,
                color: restriction.severity.color,
                size: 20,
              ),
            ),
            title: Text(
              restriction.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(restriction.category.getDisplayName(context)),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: restriction.severity.color,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      restriction.severity.getDisplayName(context),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    await _editRestriction(restriction);
                    break;
                  case 'delete':
                    await _deleteRestriction(restriction);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
