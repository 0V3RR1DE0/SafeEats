import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile {
  final String id;
  final String name;
  final List<Restriction> restrictions;
  bool isActive;

  Profile({
    String? id,
    required this.name,
    List<Restriction>? restrictions,
    this.isActive = false,
  })  : id = id ?? const Uuid().v4(),
        restrictions = restrictions ?? [];

  Profile copyWith({
    String? name,
    List<Restriction>? restrictions,
    bool? isActive,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      restrictions: restrictions ?? this.restrictions,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'restrictions': restrictions.map((r) => r.toJson()).toList(),
      'isActive': isActive,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['name'] as String,
      restrictions: (json['restrictions'] as List)
          .map((r) => Restriction.fromJson(r as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool,
    );
  }
}

class Restriction {
  final String id;
  final String name;
  final RestrictionCategory category;
  final RestrictionSeverity severity;
  final String? notes;

  Restriction({
    String? id,
    required this.name,
    required this.category,
    required this.severity,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  Restriction copyWith({
    String? name,
    RestrictionCategory? category,
    RestrictionSeverity? severity,
    String? notes,
  }) {
    return Restriction(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toString(),
      'severity': severity.toString(),
      'notes': notes,
    };
  }

  factory Restriction.fromJson(Map<String, dynamic> json) {
    return Restriction(
      id: json['id'] as String,
      name: json['name'] as String,
      category: RestrictionCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
      ),
      severity: RestrictionSeverity.values.firstWhere(
        (e) => e.toString() == json['severity'],
      ),
      notes: json['notes'] as String?,
    );
  }
}

enum RestrictionCategory {
  allergen,
  dietary,
  religious,
  medical;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case RestrictionCategory.allergen:
        return l10n.allergen;
      case RestrictionCategory.dietary:
        return l10n.dietary;
      case RestrictionCategory.religious:
        return l10n.religious;
      case RestrictionCategory.medical:
        return l10n.medical;
    }
  }
}

enum RestrictionSeverity {
  high,
  medium,
  low;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case RestrictionSeverity.high:
        return l10n.high;
      case RestrictionSeverity.medium:
        return l10n.medium;
      case RestrictionSeverity.low:
        return l10n.low;
    }
  }

  Color get color {
    switch (this) {
      case RestrictionSeverity.high:
        return Colors.red;
      case RestrictionSeverity.medium:
        return Colors.orange;
      case RestrictionSeverity.low:
        return Colors.yellow;
    }
  }
}
