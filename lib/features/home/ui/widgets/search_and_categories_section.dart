import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _imagePicker = ImagePicker();
  final Dio _dio = Dio();

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
                    // Show AI search bottom sheet
                    _showAISearchBottomSheet(context);
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

  void _showAISearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _AISearchBottomSheet(
            onSearchChanged: widget.onSearchChanged,
            onUpdateSearchController: (text) {
              _searchController.text = text;
              setState(() {});
            },
          ),
    );
  }
}

class _AISearchBottomSheet extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final Function(String) onUpdateSearchController;

  const _AISearchBottomSheet({
    this.onSearchChanged,
    required this.onUpdateSearchController,
  });

  @override
  State<_AISearchBottomSheet> createState() => _AISearchBottomSheetState();
}

class _AISearchBottomSheetState extends State<_AISearchBottomSheet> {
  File? selectedImage;
  final TextEditingController textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final Dio _dio = Dio();
  bool isLoading = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
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
            'AI Search',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload an image and add description to find similar destinations',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Image Selection Section
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child:
                selectedImage != null
                    ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            selectedImage!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImage = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : InkWell(
                      onTap: () => _showImageSourceDialog(),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to add image',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
          ),

          const SizedBox(height: 16),

          // Text Description
          TextField(
            controller: textController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Describe what you\'re looking for...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF30B0C7)),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),

          const SizedBox(height: 20),

          // Search Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  selectedImage != null || textController.text.isNotEmpty
                      ? () async {
                        if (!isLoading) {
                          setState(() {
                            isLoading = true;
                          });
                          await _performAISearch();
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF30B0C7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Text(
                        'Search with AI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Future<void> _performAISearch() async {
    try {
      // Create FormData
      var formData = FormData();

      // Add image if provided
      if (selectedImage != null) {
        formData.files.add(
          MapEntry(
            'file',
            await MultipartFile.fromFile(
              selectedImage!.path,
              filename: 'image.jpg',
            ),
          ),
        );
      }

      // Add text if provided
      if (textController.text.isNotEmpty) {
        formData.fields.add(MapEntry('body', textController.text));
      }

      // Make API request
      final response = await _dio.post(
        'https://20.74.208.111/api2/predict',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['Classes'] != null &&
            responseData['Classes'].isNotEmpty) {
          // Get the most confident prediction (first item)
          final mostConfidentClass =
              responseData['Classes'][0]['class'] as String;

          // Close the bottom sheet
          if (mounted) {
            Navigator.pop(context);

            // Perform search with the predicted class
            widget.onSearchChanged?.call(mostConfidentClass);

            // Update search controller to show the search term
            widget.onUpdateSearchController(mostConfidentClass);

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Searching for: $mostConfidentClass'),
                backgroundColor: const Color(0xFF30B0C7),
              ),
            );
          }
        } else {
          throw Exception('No predictions found');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('AI Search Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
