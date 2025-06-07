import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final IconData icon;
  final Color color;
  final bool isSelected;

  CategoryModel({
    required this.name,
    required this.icon,
    required this.color,
    this.isSelected = false,
  });

  static IconData _getIconFromCategory(String category) {
    switch (category.toLowerCase()) {
      case 'leisure tourism':
        return Icons.beach_access;
      case 'cultural & historical tourism':
        return Icons.museum;
      case 'medical tourism':
      case 'medicine': // Backend sends "Medicine" instead of "Medical Tourism"
        return Icons.local_hospital;
      case 'adventure & eco tourism':
        return Icons.hiking;
      case 'shopping tourism':
        return Icons.shopping_bag;
      case 'religious tourism':
        return Icons.church;
      case 'business & mice tourism':
        return Icons.business;
      default:
        return Icons.place;
    }
  }

  static Color _getColorFromCategory(String category) {
    switch (category.toLowerCase()) {
      case 'leisure tourism':
        return const Color(0xFF2196F3);
      case 'cultural & historical tourism':
        return const Color(0xFFFF9800);
      case 'medical tourism':
      case 'medicine': // Backend sends "Medicine" instead of "Medical Tourism"
        return const Color(0xFFF44336);
      case 'adventure & eco tourism':
        return const Color(0xFF4CAF50);
      case 'shopping tourism':
        return const Color(0xFF9C27B0);
      case 'religious tourism':
        return const Color(0xFF795548);
      case 'business & mice tourism':
        return const Color(0xFF607D8B);
      default:
        return const Color(0xFF2196F3);
    }
  }

  factory CategoryModel.fromString(String categoryName) {
    return CategoryModel(
      name: categoryName,
      icon: _getIconFromCategory(categoryName),
      color: _getColorFromCategory(categoryName),
    );
  }

  CategoryModel copyWith({
    String? name,
    IconData? icon,
    Color? color,
    bool? isSelected,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

// Available categories from backend
class AppCategories {
  static const List<String> categories = [
    'Leisure Tourism',
    'Cultural & Historical Tourism',
    'Medical Tourism',
    'Adventure & Eco Tourism',
    'Shopping Tourism',
    'Religious Tourism',
    'Business & MICE Tourism',
  ];

  // Backend category mapping - what the backend actually sends
  static const Map<String, String> backendCategoryMapping = {
    'Medical Tourism': 'Medicine',
    'Leisure Tourism': 'Leisure Tourism',
    'Cultural & Historical Tourism': 'Cultural & Historical Tourism',
    'Adventure & Eco Tourism': 'Adventure & Eco Tourism',
    'Shopping Tourism': 'Shopping Tourism',
    'Religious Tourism': 'Religious Tourism',
    'Business & MICE Tourism': 'Business & MICE Tourism',
  };

  static List<CategoryModel> getCategoryModels() {
    return categories
        .map((category) => CategoryModel.fromString(category))
        .toList();
  }

  // Convert UI category to backend category
  static String getBackendCategory(String uiCategory) {
    return backendCategoryMapping[uiCategory] ?? uiCategory;
  }

  // Convert backend category to UI category
  static String getUiCategory(String backendCategory) {
    return backendCategoryMapping.entries
        .firstWhere(
          (entry) => entry.value == backendCategory,
          orElse: () => MapEntry(backendCategory, backendCategory),
        )
        .key;
  }
}
