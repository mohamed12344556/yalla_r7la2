import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isSelected;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isSelected = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      icon: _getIconFromName(json['iconName'] ?? ''),
      color: Color(json['color'] ?? 0xFF2196F3),
      isSelected: json['isSelected'] ?? false,
    );
  }

  static IconData _getIconFromName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'mountain':
        return Icons.terrain;
      case 'beach':
        return Icons.beach_access;
      case 'forest':
        return Icons.park;
      case 'desert':
        return Icons.landscape;
      case 'boat':
        return Icons.directions_boat;
      case 'flight':
        return Icons.flight;
      case 'hiking':
        return Icons.hiking;
      case 'cabin':
        return Icons.cabin;
      default:
        return Icons.place;
    }
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
    bool? isSelected,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
