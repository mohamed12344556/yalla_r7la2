import 'package:flutter/material.dart';

import '../../data/model/category_model.dart';

class SearchAndCategoriesSection extends StatefulWidget {
  final List<CategoryModel> categories;
  final String? selectedCategory;
  final Function(String?)? onCategorySelected;
  final Function(String)? onSearchChanged;

  const SearchAndCategoriesSection({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
    this.onSearchChanged,
  });

  @override
  State<SearchAndCategoriesSection> createState() =>
      _SearchAndCategoriesSectionState();
}

class _SearchAndCategoriesSectionState
    extends State<SearchAndCategoriesSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search destinations...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                widget.onSearchChanged?.call('');
                              },
                              icon: Icon(Icons.clear, color: Colors.grey[600]),
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                    widget.onSearchChanged?.call(value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    // Show filter options
                    _showFilterBottomSheet(context);
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Reset to show all destinations
                  widget.onCategorySelected?.call(null);
                },
                child: Text(
                  widget.selectedCategory != null ? "Clear" : "See All",
                  style: const TextStyle(
                    color: Color(0xFF30B0C7),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
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
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                final category = widget.categories[index];
                final isSelected = category.isSelected;

                return GestureDetector(
                  onTap: () {
                    widget.onCategorySelected?.call(category.name);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? category.color : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color:
                            isSelected ? category.color : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: category.color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                              : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category.icon,
                          size: 20,
                          color: isSelected ? Colors.white : category.color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Filter Options',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Price Range
                const Text(
                  'Price Range',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                // Add filter options here
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Filter options will be implemented here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 20),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF30B0C7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
