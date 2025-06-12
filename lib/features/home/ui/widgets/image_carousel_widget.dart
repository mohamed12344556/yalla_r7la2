import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../favorites/ui/logic/favorites_cubit.dart';
import '../../data/model/destination_model.dart';
import 'image_gallery_dialog.dart';

class ImageCarouselWidget extends StatelessWidget {
  final DestinationModel card;
  final PageController pageController;
  final int currentImageIndex;
  final Function(int) onImageIndexChanged;
  final Function(BuildContext, bool) onFeedbackShow;

  const ImageCarouselWidget({
    super.key,
    required this.card,
    required this.pageController,
    required this.currentImageIndex,
    required this.onImageIndexChanged,
    required this.onFeedbackShow,
  });

  void _goToImage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showImageGallery(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder:
          (context) => ImageGalleryDialog(
            images: card.imageUrls,
            initialIndex: currentImageIndex,
            destinationId: card.destinationId,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageBytes = card.imageUrls; // Using memory bytes
    final hasMultipleImages = imageBytes.length > 1;

    return SliverAppBar(
      scrolledUnderElevation: 0,
      expandedHeight: 320,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        if (hasMultipleImages)
          Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${currentImageIndex + 1}/${imageBytes.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFavorite = context.read<FavoritesCubit>().isFavorite(
                card.destinationId,
              );

              return IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black87,
                    size: 22,
                    key: ValueKey(isFavorite),
                  ),
                ),
                onPressed: () {
                  context.read<FavoritesCubit>().toggleFavorite(card);
                  onFeedbackShow(context, !isFavorite);
                },
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            GestureDetector(
              onTap:
                  hasMultipleImages ? () => _showImageGallery(context) : null,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: onImageIndexChanged,
                itemCount: imageBytes.length,
                itemBuilder: (context, index) {
                  return Hero(
                    tag: 'destination_${card.destinationId}_$index',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            imageBytes[index],
                          ), // Using Memory Image
                          fit: BoxFit.cover,
                          onError: (error, stackTrace) {
                            print('Error loading image: $error');
                          },
                        ),
                      ),
                      child:
                          imageBytes[index].isEmpty
                              ? Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                              : null,
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
            if (hasMultipleImages)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imageBytes.length,
                    (index) => GestureDetector(
                      onTap: () => _goToImage(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == currentImageIndex ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color:
                              index == currentImageIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                          boxShadow: [
                            if (index == currentImageIndex)
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                          ],
                        ),
                      ),
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
