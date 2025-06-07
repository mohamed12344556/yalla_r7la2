import 'package:flutter/material.dart';
import 'package:yalla_r7la2/features/home/data/model/destination_model.dart';
import 'package:yalla_r7la2/features/home/ui/widgets/image_thumbnails_widget.dart';

import 'image_gallery_dialog.dart';

class ContentSectionWidget extends StatelessWidget {
  final DestinationModel card;
  final PageController pageController;
  final int currentImageIndex;
  final Function(int) onImageIndexChanged;

  const ContentSectionWidget({
    super.key,
    required this.card,
    required this.pageController,
    required this.currentImageIndex,
    required this.onImageIndexChanged,
  });

  void _showImageGallery(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder:
          (context) => ImageGalleryDialog(
            images: card.allImageBytes, // Using memory bytes
            initialIndex: currentImageIndex,
            destinationId: card.destinationId,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageBytes = card.allImageBytes; // Using memory bytes
    final hasMultipleImages = imageBytes.length > 1;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Rating Section
            _buildTitleSection(),
            const SizedBox(height: 24),

            // Photo Gallery Button
            if (hasMultipleImages) _buildPhotoGalleryButton(context),

            // Image Thumbnails
            if (hasMultipleImages)
              ImageThumbnailsWidget(
                images: imageBytes, // Using memory bytes
                currentImageIndex: currentImageIndex,
                pageController: pageController,
              ),

            // Price Section
            _buildPriceSection(),
            const SizedBox(height: 24),

            // Description Section
            _buildSection(
              'About This Destination',
              card.description ??
                  'Discover this amazing destination with breathtaking views and unforgettable experiences. Perfect for travelers seeking adventure and natural beauty.',
            ),
            const SizedBox(height: 24),

            // Features Section
            if (card.features != null && card.features!.isNotEmpty)
              _buildFeaturesSection(),

            // Map Section
            _buildMapSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.name ?? 'Destination',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      card.location ?? 'Unknown Location',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.blue[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                card.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGalleryButton(BuildContext context) {
    final imageBytes = card.allImageBytes;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: () => _showImageGallery(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueAccent.withOpacity(0.05),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.photo_library,
                color: Colors.blueAccent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'View Photo Gallery',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Text(
                      '${imageBytes.length} photos available',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.blueAccent,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Starting Price',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$${card.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    TextSpan(
                      text: ' /person',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (card.category != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                card.category!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('What\'s Included'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              card.features!.map((feature) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.3),
                    ),
                    boxShadow: [
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
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        feature,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMapSection() {
    return _buildSection(
      'Location',
      null,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'Interactive Map',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Coming Soon',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'View',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
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

  Widget _buildSection(String title, String? content, {Widget? child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 12),
        if (child != null)
          child
        else if (content != null)
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
