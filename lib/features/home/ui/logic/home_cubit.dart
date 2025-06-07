import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/category_model.dart';
import '../../data/model/destination_model.dart';
import '../../data/repos/destination_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DestinationRepo destinationRepo;

  HomeCubit({required this.destinationRepo}) : super(HomeInitial());

  List<DestinationModel> allDestinations = [];
  List<CategoryModel> categories = AppCategories.getCategoryModels();
  String selectedCategory = '';
  DestinationModel? currentDestinationDetails;

  // Load all destinations
  Future<void> loadDestinations() async {
    emit(HomeLoading());
    try {
      allDestinations = await destinationRepo.getAllDestinations();
      emit(HomeLoaded(destinations: allDestinations, categories: categories));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  // Load destinations by category
  Future<void> loadDestinationsByCategory(String category) async {
    emit(HomeLoading());
    try {
      selectedCategory = category;
      final destinations = await destinationRepo.getDestinationsByCategory(
        AppCategories.getBackendCategory(category),
      );

      // Update categories selection
      categories =
          categories
              .map((cat) => cat.copyWith(isSelected: cat.name == category))
              .toList();

      emit(
        HomeLoaded(
          destinations: destinations,
          categories: categories,
          selectedCategory: category,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  // Reset to all destinations
  void resetToAllDestinations() {
    selectedCategory = '';
    categories =
        categories.map((cat) => cat.copyWith(isSelected: false)).toList();

    emit(HomeLoaded(destinations: allDestinations, categories: categories));
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
}
