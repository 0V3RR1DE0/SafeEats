import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String name;
  final List<String> restrictedItems;

  UserProfile({required this.name, required this.restrictedItems});

  // Convert UserProfile to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'restrictedItems': restrictedItems,
    };
  }

  // Create UserProfile from JSON map
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      restrictedItems: List<String>.from(json['restrictedItems']),
    );
  }
}
