// lib/screens/restrictions_screen.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/app_scaffold.dart';

class RestrictionsScreen extends StatefulWidget {
  @override
  _RestrictionsScreenState createState() => _RestrictionsScreenState();
}

class _RestrictionsScreenState extends State<RestrictionsScreen> {
  final StorageService _storageService = StorageService();
  List<String> _restrictions = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRestrictions();
  }

  Future<void> _loadRestrictions() async {
    final restrictions = await _storageService.getRestrictions();
    setState(() {
      _restrictions = restrictions;
    });
  }

  void _addRestriction(String restriction) {
    if (restriction.isNotEmpty && !_restrictions.contains(restriction.toLowerCase())) {
      setState(() {
        _restrictions.add(restriction.toLowerCase());
      });
      _storageService.saveRestrictions(_restrictions);
      _controller.clear();
    }
  }

  void _removeRestriction(String restriction) {
    setState(() {
      _restrictions.remove(restriction);
    });
    _storageService.saveRestrictions(_restrictions);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Manage Restrictions',
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter a food restriction',
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                child: Text('Add'),
                onPressed: () => _addRestriction(_controller.text),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _restrictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_restrictions[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeRestriction(_restrictions[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}