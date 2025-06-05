part of 'favorites_cubit.dart';

@immutable
sealed class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  final List<DestinationModel> favorites;

  FavoritesLoaded(this.favorites);
}

final class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}
