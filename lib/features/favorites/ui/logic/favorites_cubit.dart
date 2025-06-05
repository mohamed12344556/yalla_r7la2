import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:yalla_r7la2/core/cache/shared_pref_helper.dart';
import 'package:yalla_r7la2/features/home/data/model/destination_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial()) {
    loadFavorites();
  }

  List<DestinationModel> _favorites = [];

  List<DestinationModel> get favorites => _favorites;

  static const String _favoritesKey = 'user_favorites';

  Future<void> loadFavorites() async {
    try {
      emit(FavoritesLoading());

      final favoritesString = await SharedPrefHelper.getString(_favoritesKey);

      if (favoritesString.isNotEmpty) {
        final List<dynamic> favoritesJson = json.decode(favoritesString);
        _favorites =
            favoritesJson.map((json) => _destinationFromJson(json)).toList();
      }

      emit(FavoritesLoaded(_favorites));
    } catch (e) {
      emit(FavoritesError('Failed to load favorites: $e'));
    }
  }

  Future<void> toggleFavorite(DestinationModel destination) async {
    try {
      final existingIndex = _favorites.indexWhere(
        (fav) => fav.destinationId == destination.destinationId,
      );

      if (existingIndex != -1) {
        // Remove from favorites
        _favorites.removeAt(existingIndex);
      } else {
        // Add to favorites
        final favoriteDestination = DestinationModel(
          destinationId: destination.destinationId,
          name: destination.name,
          imageUrl: destination.imageUrl,
          images: destination.images,
          location: destination.location,
          secondaryLocation: destination.secondaryLocation,
          rating: destination.rating,
          price: destination.price,
          description: destination.description,
          features: destination.features,
          isFavorite: true,
          category: destination.category,
        );
        _favorites.add(favoriteDestination);
      }

      // Save to SharedPreferences
      await _saveFavorites();

      emit(FavoritesLoaded(List.from(_favorites)));
    } catch (e) {
      emit(FavoritesError('Failed to toggle favorite: $e'));
    }
  }

  bool isFavorite(String destinationId) {
    return _favorites.any((fav) => fav.destinationId == destinationId);
  }

  Future<void> _saveFavorites() async {
    try {
      final favoritesJson =
          _favorites
              .map((destination) => _destinationToJson(destination))
              .toList();
      final favoritesString = json.encode(favoritesJson);
      await SharedPrefHelper.setData(_favoritesKey, favoritesString);
    } catch (e) {
      throw Exception('Failed to save favorites: $e');
    }
  }

  Map<String, dynamic> _destinationToJson(DestinationModel destination) {
    return {
      'destinationId': destination.destinationId,
      'name': destination.name,
      'imageUrl': destination.imageUrl,
      'images': destination.images,
      'location': destination.location,
      'secondaryLocation': destination.secondaryLocation,
      'rating': destination.rating,
      'price': destination.price,
      'description': destination.description,
      'features': destination.features,
      'isFavorite': destination.isFavorite,
      'category': destination.category,
    };
  }

  DestinationModel _destinationFromJson(Map<String, dynamic> json) {
    return DestinationModel(
      destinationId: json['destinationId'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      location: json['location'] ?? '',
      secondaryLocation: json['secondaryLocation'] ?? '',
      rating: json['rating']?.toDouble(),
      price: json['price']?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      features:
          json['features'] != null ? List<String>.from(json['features']) : null,
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'],
    );
  }

  Future<void> clearAllFavorites() async {
    try {
      _favorites.clear();
      await SharedPrefHelper.removeData(_favoritesKey);
      emit(FavoritesLoaded([]));
    } catch (e) {
      emit(FavoritesError('Failed to clear favorites: $e'));
    }
  }
}
