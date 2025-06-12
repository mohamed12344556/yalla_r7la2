import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageThumbnailsWidget extends StatelessWidget {
  final List<String> images; // Changed to Uint8List for memory images
  final int currentImageIndex;
  final PageController pageController;

  const ImageThumbnailsWidget({
    super.key,
    required this.images,
    required this.currentImageIndex,
    required this.pageController,
  });

  void _goToImage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final isSelected = index == currentImageIndex;
          return GestureDetector(
            onTap: () => _goToImage(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blueAccent : Colors.grey[300]!,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                        : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:
                    images[index].isNotEmpty
                        ? Image.network(
                          images[index], // Using Memory Image
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                        : Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        ),
              ),
            ),
          );
        },
      ),
    );
  }
}
