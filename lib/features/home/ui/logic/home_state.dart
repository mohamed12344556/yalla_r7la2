part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<DestinationModel> destinations;
  final List<CategoryModel> categories;
  final String? selectedCategory;

  HomeLoaded({
    required this.destinations,
    required this.categories,
    this.selectedCategory,
  });
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
