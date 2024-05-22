import 'package:flutter/material.dart';
import 'user_profile_provider.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';

class SettingsScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _restrictionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProfileProvider profileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Profile Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _restrictionsController,
              decoration: InputDecoration(
                labelText: 'Food Restrictions (comma separated)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                List<String> restrictions = _restrictionsController.text.split(',').map((e) => e.trim()).toList();

                if (name.isNotEmpty && restrictions.isNotEmpty) {
                  profileProvider.addProfile(UserProfile(name: name, restrictedItems: restrictions));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile added')),
                  );
                  _nameController.clear();
                  _restrictionsController.clear();
                }
              },
              child: Text('Add Profile'),
            ),
            SizedBox(height: 10),
            Text('Profiles:'),
            Expanded(
              child: ListView.builder(
                itemCount: profileProvider.profiles.length,
                itemBuilder: (context, index) {
                  UserProfile profile = profileProvider.profiles[index];
                  return ListTile(
                    title: Text(profile.name),
                    subtitle: Text('Restrictions: ${profile.restrictedItems.join(', ')}'),
                    onTap: () {
                      profileProvider.setActiveProfile(profile);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Active Profile: ${profile.name}')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}