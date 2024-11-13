import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  late Future<ProfileService> _profileServiceFuture;
  List<Profile> _profiles = [];

  @override
  void initState() {
    super.initState();
    _profileServiceFuture = ProfileService.create();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final service = await _profileServiceFuture;
    final profiles = await service.getProfiles();
    setState(() {
      _profiles = profiles;
    });
  }

  Future<void> _addProfile(String name) async {
    final service = await _profileServiceFuture;
    final profile = Profile(name: name);
    await service.addProfile(profile);
    await _loadProfiles();
  }

  Future<void> _editProfile(Profile profile, String newName) async {
    final service = await _profileServiceFuture;
    final updatedProfile = profile.copyWith(name: newName);
    await service.updateProfile(updatedProfile);
    await _loadProfiles();
  }

  Future<void> _deleteProfile(String profileId) async {
    final service = await _profileServiceFuture;
    await service.deleteProfile(profileId);
    await _loadProfiles();
  }

  Future<void> _toggleActive(Profile profile) async {
    final service = await _profileServiceFuture;
    await service.setActiveProfile(profile.id);
    await _loadProfiles();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
      ),
      body: _profiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No profiles yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Add a profile to get started'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddProfileDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Profile'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _profiles.length,
              itemBuilder: (context, index) {
                final profile = _profiles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(profile.name),
                    subtitle: Text(
                      '${profile.restrictions.length} restrictions',
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      child: Text(
                        profile.name.substring(0, 1).toUpperCase(),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: profile.isActive,
                          onChanged: (_) => _toggleActive(profile),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditProfileDialog(
                            context,
                            profile,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.list),
                          onPressed: () => _manageRestrictions(profile),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _showDeleteConfirmation(
                            context,
                            profile,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _profiles.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () => _showAddProfileDialog(context),
              child: const Icon(Icons.add),
            ),
    );
  }

  Future<void> _showAddProfileDialog(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Profile'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Profile Name',
            hintText: 'Enter profile name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context, name);
              }
            },
            child: const Text('Add'),
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
    Profile profile,
  ) async {
    final controller = TextEditingController(text: profile.name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Profile Name',
            hintText: 'Enter profile name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context, name);
              }
            },
            child: const Text('Save'),
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
    Profile profile,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text(
          'Are you sure you want to delete ${profile.name}? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
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

  @override
  void initState() {
    super.initState();
    _restrictions = List.from(widget.profile.restrictions);
  }

  Future<void> _addRestriction(String foodItem) async {
    final restriction = Restriction(
      name: foodItem,
      category: widget.profileService.getCategoryForRestriction(foodItem),
      severity: RestrictionSeverity.high,
    );

    setState(() {
      _restrictions.add(restriction);
    });

    // Save immediately
    final updatedProfile = widget.profile.copyWith(
      restrictions: _restrictions,
    );
    await widget.profileService.updateProfile(updatedProfile);
  }

  Future<void> _deleteRestriction(Restriction restriction) async {
    setState(() {
      _restrictions.removeWhere((r) => r.id == restriction.id);
    });

    // Save immediately
    final updatedProfile = widget.profile.copyWith(
      restrictions: _restrictions,
    );
    await widget.profileService.updateProfile(updatedProfile);
  }

  void _showAddRestrictionDialog() {
    final commonRestrictions = widget.profileService.getCommonRestrictions();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Food Restriction'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Common Restrictions:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: commonRestrictions.map((restriction) {
                  return ActionChip(
                    label: Text(restriction),
                    onPressed: () {
                      Navigator.pop(context);
                      _addRestriction(restriction);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Custom Food Item',
                  hintText: 'Enter food item to restrict',
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Navigator.pop(context);
                    _addRestriction(value.trim());
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.profile.name}\'s Restrictions'),
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
                    'No restrictions yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Add food items to restrict'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _showAddRestrictionDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Restriction'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _restrictions.length,
              itemBuilder: (context, index) {
                final restriction = _restrictions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(restriction.name),
                    subtitle: Text(restriction.category.displayName),
                    leading: Icon(
                      Icons.block,
                      color: restriction.severity.color,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteRestriction(restriction),
                    ),
                  ),
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
