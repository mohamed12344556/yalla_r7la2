part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<DestinationModel> destinations;
  final List<CategoryModel> categories;
  final String? selectedCategory;

  // Pagination fields
  final int currentPage;
  final int totalPages;
  final int totalRecords;
  final bool hasMorePages;

  // Search and filter state
  final bool isSearching;
  final bool isFiltered;
  final String? searchQuery;

  HomeLoaded({
    required this.destinations,
    required this.categories,
    this.selectedCategory,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalRecords = 0,
    this.hasMorePages = false,
    this.isSearching = false,
    this.isFiltered = false,
    this.searchQuery,
  });

  HomeLoaded copyWith({
    List<DestinationModel>? destinations,
    List<CategoryModel>? categories,
    String? selectedCategory,
    int? currentPage,
    int? totalPages,
    int? totalRecords,
    bool? hasMorePages,
    bool? isSearching,
    bool? isFiltered,
    String? searchQuery,
  }) {
    return HomeLoaded(
      destinations: destinations ?? this.destinations,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalRecords: totalRecords ?? this.totalRecords,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isSearching: isSearching ?? this.isSearching,
      isFiltered: isFiltered ?? this.isFiltered,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Helper getters
  bool get canLoadMore => hasMorePages && !isSearching && !isFiltered;
  String get paginationInfo =>
      'Showing ${destinations.length} of $totalRecords destinations';
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == totalPages;
}

final class HomeDetailsLoading extends HomeState {}

final class HomeDetailsLoaded extends HomeState {
  final DestinationModel destination;

  HomeDetailsLoaded({required this.destination});
}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
