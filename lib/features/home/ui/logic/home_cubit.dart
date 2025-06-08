import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/category_model.dart';
import '../../data/model/destination_model.dart';
import '../../data/repos/destination_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DestinationRepo destinationRepo;

  HomeCubit({required this.destinationRepo}) : super(HomeInitial());

  // Pagination state
  List<DestinationModel> allDestinations = [];
  List<CategoryModel> categories = AppCategories.getCategoryModels();
  String selectedCategory = '';
  DestinationModel? currentDestinationDetails;

  // Pagination tracking
  int currentPage = 1;
  int totalPages = 1;
  int totalRecords = 0;
  bool isLoadingMore = false;
  static const int pageSize = 6;

  // Load first page of destinations with images
  Future<void> loadDestinations({bool loadImages = true}) async {
    emit(HomeLoading());
    try {
      final response = await destinationRepo.getAllDestinations(
        pageNumber: 1,
        pageSize: pageSize,
      );

      allDestinations = response.data;
      currentPage = response.pageNumber;
      totalPages = response.totalPages;
      totalRecords = response.totalRecords;

      // Always load images for getAllDestinations
      if (loadImages && allDestinations.isNotEmpty) {
        try {
          allDestinations = await destinationRepo.loadImagesForDestinations(
            allDestinations,
          );
        } catch (e) {
          print('Warning: Failed to load some images: $e');
          // Continue with destinations even if some images fail to load
        }
      }

      emit(
        HomeLoaded(
          destinations: allDestinations,
          categories: categories,
          currentPage: currentPage,
          totalPages: totalPages,
          totalRecords: totalRecords,
          hasMorePages: currentPage < totalPages,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  // Load more destinations (pagination) with images
  Future<void> loadMoreDestinations({bool loadImages = true}) async {
    if (isLoadingMore || currentPage >= totalPages) return;

    isLoadingMore = true;
    final nextPage = currentPage + 1;

    try {
      final response =
          selectedCategory.isEmpty
              ? await destinationRepo.getAllDestinations(
                pageNumber: nextPage,
                pageSize: pageSize,
              )
              : await destinationRepo.getDestinationsByCategory(
                AppCategories.getBackendCategory(selectedCategory),
                pageNumber: nextPage,
                pageSize: pageSize,
              );

      var newDestinations = response.data;

      // Load images for getAllDestinations only (category destinations already have images)
      if (loadImages &&
          selectedCategory.isEmpty &&
          newDestinations.isNotEmpty) {
        try {
          newDestinations = await destinationRepo.loadImagesForDestinations(
            newDestinations,
          );
        } catch (e) {
          print('Warning: Failed to load some images: $e');
          // Continue with destinations even if some images fail to load
        }
      }

      allDestinations.addAll(newDestinations);
      currentPage = response.pageNumber;

      emit(
        HomeLoaded(
          destinations: allDestinations,
          categories: categories,
          selectedCategory: selectedCategory.isEmpty ? null : selectedCategory,
          currentPage: currentPage,
          totalPages: totalPages,
          totalRecords: totalRecords,
          hasMorePages: currentPage < totalPages,
        ),
      );
    } catch (e) {
      emit(HomeError('Failed to load more destinations: $e'));
    } finally {
      isLoadingMore = false;
    }
  }

  // Load destinations by category with pagination
  Future<void> loadDestinationsByCategory(String category) async {
    emit(HomeLoading());
    try {
      selectedCategory = category;
      final response = await destinationRepo.getDestinationsByCategory(
        AppCategories.getBackendCategory(category),
        pageNumber: 1,
        pageSize: pageSize,
      );

      allDestinations = response.data;
      currentPage = response.pageNumber;
      totalPages = response.totalPages;
      totalRecords = response.totalRecords;

      // Category destinations already have images, no need to load separately
      // But we can add a safety check if needed

      // Update categories selection
      categories =
          categories
              .map((cat) => cat.copyWith(isSelected: cat.name == category))
              .toList();

      emit(
        HomeLoaded(
          destinations: allDestinations,
          categories: categories,
          selectedCategory: category,
          currentPage: currentPage,
          totalPages: totalPages,
          totalRecords: totalRecords,
          hasMorePages: currentPage < totalPages,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  // Reset to all destinations
  void resetToAllDestinations() {
    selectedCategory = '';
    currentPage = 1;
    categories =
        categories.map((cat) => cat.copyWith(isSelected: false)).toList();

    loadDestinations(); // This will load images by default
  }

  // Get destination details
  Future<void> getDestinationDetails(String destinationId) async {
    emit(HomeDetailsLoading());
    try {
      currentDestinationDetails = await destinationRepo.getDestinationDetails(
        destinationId,
      );
      emit(HomeDetailsLoaded(destination: currentDestinationDetails!));
    } catch (e) {
      emit(HomeError('Failed to load destination details: $e'));
    }
  }

  // Clear destination details
  void clearDestinationDetails() {
    currentDestinationDetails = null;
  }

  // Refresh destinations (reload first page)
  Future<void> refreshDestinations() async {
    currentPage = 1;
    allDestinations.clear();

    if (selectedCategory.isEmpty) {
      await loadDestinations(); // Will load images
    } else {
      await loadDestinationsByCategory(selectedCategory);
    }
  }

  // Search destinations by name (local search for now)
  void searchDestinations(String query) {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    if (query.isEmpty) {
      emit(
        currentState.copyWith(
          destinations: allDestinations,
          isSearching: false,
        ),
      );
      return;
    }

    final filteredDestinations =
        allDestinations
            .where(
              (destination) =>
                  destination.name.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  (destination.description?.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ??
                      false) ||
                  (destination.location?.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ??
                      false),
            )
            .toList();

    emit(
      currentState.copyWith(
        destinations: filteredDestinations,
        isSearching: true,
        searchQuery: query,
      ),
    );
  }

  // Server-side search with pagination (if supported by API)
  Future<void> searchDestinationsOnServer(String query) async {
    if (query.isEmpty) {
      resetToAllDestinations();
      return;
    }

    emit(HomeLoading());
    try {
      // Assuming you have a search endpoint
      final response = await destinationRepo.searchDestinations(
        query,
        pageNumber: 1,
        pageSize: pageSize,
      );

      allDestinations = response.data;
      currentPage = response.pageNumber;
      totalPages = response.totalPages;
      totalRecords = response.totalRecords;

      // Load images for search results if needed
      if (allDestinations.isNotEmpty) {
        try {
          allDestinations = await destinationRepo.loadImagesForDestinations(
            allDestinations,
          );
        } catch (e) {
          print('Warning: Failed to load some images for search results: $e');
        }
      }

      emit(
        HomeLoaded(
          destinations: allDestinations,
          categories: categories,
          currentPage: currentPage,
          totalPages: totalPages,
          totalRecords: totalRecords,
          hasMorePages: currentPage < totalPages,
          isSearching: true,
          searchQuery: query,
        ),
      );
    } catch (e) {
      emit(HomeError('Search failed: $e'));
    }
  }

  // Filter destinations by price range (local filter)
  void filterByPriceRange(double minPrice, double maxPrice) {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    final filteredDestinations =
        allDestinations.where((destination) {
          final price = destination.price;
          return price >= minPrice && price <= maxPrice;
        }).toList();

    emit(
      currentState.copyWith(
        destinations: filteredDestinations,
        isFiltered: true,
      ),
    );
  }

  // Sort destinations
  void sortDestinations(SortOption sortOption) {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    final sortedDestinations = List<DestinationModel>.from(
      currentState.destinations,
    );

    switch (sortOption) {
      case SortOption.nameAscending:
        sortedDestinations.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDescending:
        sortedDestinations.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.priceAscending:
        sortedDestinations.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDescending:
        sortedDestinations.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.ratingDescending:
        sortedDestinations.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    emit(currentState.copyWith(destinations: sortedDestinations));
  }

  // Clear all filters and searches
  void clearFiltersAndSearch() {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    emit(
      currentState.copyWith(
        destinations: allDestinations,
        isSearching: false,
        isFiltered: false,
        searchQuery: null,
      ),
    );
  }

  // Get pagination info
  String getPaginationInfo() {
    if (state is HomeLoaded) {
      final loaded = state as HomeLoaded;
      final showing = loaded.destinations.length;
      return 'Showing $showing of $totalRecords destinations (Page $currentPage of $totalPages)';
    }
    return '';
  }

  // Helper method to preload images for better performance
  Future<void> preloadImagesForNextPage() async {
    if (currentPage < totalPages && !isLoadingMore) {
      final nextPage = currentPage + 1;
      try {
        final response =
            selectedCategory.isEmpty
                ? await destinationRepo.getAllDestinations(
                  pageNumber: nextPage,
                  pageSize: pageSize,
                )
                : await destinationRepo.getDestinationsByCategory(
                  AppCategories.getBackendCategory(selectedCategory),
                  pageNumber: nextPage,
                  pageSize: pageSize,
                );

        // Preload images in background for getAllDestinations
        if (selectedCategory.isEmpty && response.data.isNotEmpty) {
          destinationRepo.loadImagesForDestinations(response.data);
        }
      } catch (e) {
        print('Preload failed: $e');
      }
    }
  }
}

enum SortOption {
  nameAscending,
  nameDescending,
  priceAscending,
  priceDescending,
  ratingDescending,
}
