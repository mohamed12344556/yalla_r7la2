import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../favorites/ui/logic/favorites_cubit.dart';
import '../../data/model/category_model.dart';
import '../../data/model/destination_model.dart';

class DestinationCardContent extends StatelessWidget {
  final DestinationModel cardData;

  const DestinationCardContent({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Image Section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Stack(
                  children: [
                    // Image with proper handling using Image.memory
                    _buildImageWidget(),

                    // Enhanced Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),

                    // Enhanced Heart Icon with Animation
                    Positioned(
                      top: 12,
                      right: 12,
                      child: _buildFavoriteButton(context),
                    ),

                    // Enhanced Rating Badge
                    if (cardData.averageRating != null)
                      Positioned(top: 12, left: 12, child: _buildRatingBadge()),

                    // Discount Badge
                    if (cardData.discount != null && cardData.discount! > 0)
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: _buildDiscountBadge(),
                      ),

                    // Popular Badge for high-priced items
                    if (cardData.cost != null && cardData.cost! > 500)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: _buildPopularBadge(),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Enhanced Content Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardData.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212121),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (cardData.location != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                cardData.location!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      if (cardData.description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            cardData.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cardData.cost != null) ...[
                              RichText(
                                text: TextSpan(
                                  children: [
                                    if (cardData.discount != null &&
                                        cardData.discount! > 0) ...[
                                      TextSpan(
                                        text:
                                            '\$${cardData.cost!.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(text: ' '),
                                    ],
                                    TextSpan(
                                      text:
                                          cardData.discount != null &&
                                                  cardData.discount! > 0
                                              ? '\$${(cardData.cost! * (1 - cardData.discount! / 100)).toStringAsFixed(0)}'
                                              : '\$${cardData.cost!.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF2196F3),
                                        height: 1,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' /person',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (cardData.availableNumber != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    '${cardData.availableNumber} spots available',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          cardData.availableNumber! < 10
                                              ? Colors.red[600]
                                              : Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ] else
                              const Text(
                                'Price on request',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2196F3),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (cardData.category != null) _buildCategoryBadge(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    // Use imageBytes getter from DestinationModel
    final imageBytes = cardData.imageUrl;

    if (imageBytes.isNotEmpty) {
      return Image.network(
        imageBytes,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image from memory: $error');
          return _buildPlaceholderImage(hasError: true);
        },
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage({bool hasError = false}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              hasError
                  ? [Colors.grey[200]!, Colors.grey[300]!]
                  : [
                    const Color(0xFF2196F3).withOpacity(0.1),
                    const Color(0xFF2196F3).withOpacity(0.2),
                  ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              hasError
                  ? Icons.image_not_supported_outlined
                  : Icons.photo_camera_outlined,
              size: 32,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            hasError ? 'Image failed to load' : 'No Image Available',
            style: TextStyle(
              color: Colors.grey[hasError ? 600 : 700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFavorite = context.read<FavoritesCubit>().isFavorite(
          cardData.destinationId,
        );

        return GestureDetector(
          onTap: () {
            context.read<FavoritesCubit>().toggleFavorite(cardData);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      isFavorite ? Icons.heart_broken : Icons.favorite,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isFavorite
                          ? 'Removed from favorites'
                          : 'Added to favorites',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                backgroundColor:
                    isFavorite
                        ? const Color(0xFFFF9800)
                        : const Color(0xFF4CAF50),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isFavorite
                      ? Colors.red.withOpacity(0.9)
                      : Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.white : Colors.red,
                size: 20,
                key: ValueKey(isFavorite),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            cardData.averageRating!.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E63).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '${cardData.discount!.toInt()}% OFF',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildPopularBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'POPULAR',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    final categoryModel = CategoryModel.fromString(cardData.category!);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryModel.color.withOpacity(0.1),
            categoryModel.color.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: categoryModel.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(categoryModel.icon, size: 12, color: categoryModel.color),
          const SizedBox(width: 4),
          Text(
            cardData.category!,
            style: TextStyle(
              fontSize: 11,
              color: categoryModel.color,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
