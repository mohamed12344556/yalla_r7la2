import 'package:flutter/material.dart';
import 'package:p1/features/destinations/data/models/category_model.dart';

class SearchAndCategoriesSection extends StatefulWidget {
  const SearchAndCategoriesSection({super.key});

  @override
  State<SearchAndCategoriesSection> createState() =>
      _SearchAndCategoriesSectionState();
}

class _SearchAndCategoriesSectionState
    extends State<SearchAndCategoriesSection> {
  int selectedCategoryIndex = -1;

  final List<CategoryModel> categories = [
    CategoryModel(
      id: '1',
      name: "Mountain",
      icon: Icons.terrain,
      color: const Color(0xFF30B0C7),
    ),
    CategoryModel(
      id: '2',
      name: "Beach",
      icon: Icons.beach_access,
      color: const Color(0xFF30B0C7),
    ),
    CategoryModel(
      id: '3',
      name: "Forest",
      icon: Icons.park,
      color: const Color(0xFF30B0C7),
    ),
    CategoryModel(
      id: '4',
      name: "Desert",
      icon: Icons.landscape,
      color: const Color(0xFF30B0C7),
    ),
    CategoryModel(
      id: '5',
      name: "Boat",
      icon: Icons.directions_boat,
      color: const Color(0xFF30B0C7),
    ),
    CategoryModel(
      id: '6',
      name: "Flight",
      icon: Icons.flight,
      color: const Color(0xFF30B0C7),
    ),
    CategoryModel(
      id: '7',
      name: "Hiking",
      icon: Icons.hiking,
      color: const Color(0xFF30B0C7),
    ),
    CategoryModel(
      id: '8',
      name: "Cabin",
      icon: Icons.cabin,
      color: const Color(0xFF30B0C7),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search destinations...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    // Handle search
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    // Show filter options
                  },
                  icon: const Icon(Icons.tune, color: Color(0xFF30B0C7)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Categories Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all categories
                },
                child: const Text(
                  "See All",
                  style: TextStyle(color: Color(0xFF30B0C7), fontSize: 14),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Categories List
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedCategoryIndex;
                final category = categories[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = isSelected ? -1 : index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFF30B0C7) : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xFF30B0C7)
                                : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category.icon,
                          size: 20,
                          color:
                              isSelected
                                  ? Colors.white
                                  : const Color(0xFF30B0C7),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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
