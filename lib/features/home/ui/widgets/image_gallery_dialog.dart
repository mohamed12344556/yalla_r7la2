import 'package:flutter/material.dart';

class ImageGalleryDialog extends StatefulWidget {
  final List<String> images; 
  final int initialIndex;
  final String destinationId;
  final ValueChanged<int>? onPageChanged;

  const ImageGalleryDialog({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.destinationId,
    this.onPageChanged,
  });

  @override
  State<ImageGalleryDialog> createState() => _ImageGalleryDialogState();
}

class _ImageGalleryDialogState extends State<ImageGalleryDialog> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          // Full screen image viewer
          PageView.builder(
            controller: PageController(initialPage: widget.initialIndex),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
              widget.onPageChanged?.call(index);
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Center(
                  child: Hero(
                    tag: 'destination_${widget.destinationId}_$index',
                    child:
                        widget.images[index].isNotEmpty
                            ? Image.network(
                              widget.images[index],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 64,
                                  ),
                                );
                              },
                            )
                            : const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.white,
                                size: 64,
                              ),
                            ),
                  ),
                ),
              );
            },
          ),

          // Close button
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),

          // Image counter
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${currentIndex + 1} / ${widget.images.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
