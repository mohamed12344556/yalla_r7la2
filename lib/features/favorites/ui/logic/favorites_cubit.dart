import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/cache/shared_pref_helper.dart';
import '../../../home/data/model/destination_model.dart';

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
        // Add to favorites - create a simplified version for storage
        final favoriteDestination = DestinationModel(
          destinationId: destination.destinationId,
          name: destination.name,
          description: destination.description,
          location: destination.location,
          category: destination.category,
          averageRating: destination.averageRating,
          discount: destination.discount,
          cost: destination.cost,
          availableNumber: destination.availableNumber,
          startDate: destination.startDate,
          endDate: destination.endDate,
          isAvailable: destination.isAvailable,
          businessOwnerId: destination.businessOwnerId,
          images: destination.images,
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
      'description': destination.description,
      'location': destination.location,
      'category': destination.category,
      'averageRating': destination.averageRating,
      'discount': destination.discount,
      'cost': destination.cost,
      'availableNumber': destination.availableNumber,
      'startDate': destination.startDate?.toIso8601String(),
      'endDate': destination.endDate?.toIso8601String(),
      'isAvailable': destination.isAvailable,
      'businessOwnerId': destination.businessOwnerId,
      'images':
          destination.images
              ?.map(
                (img) => {
                  'imageId': img.imageId,
                  'imageBase64': img.imageUrl,
                },
              )
              .toList(),
    };
  }

  DestinationModel _destinationFromJson(Map<String, dynamic> json) {
    return DestinationModel(
      destinationId: json['destinationId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      location: json['location'],
      category: json['category'],
      averageRating: json['averageRating']?.toDouble(),
      discount: json['discount']?.toDouble(),
      cost: json['cost']?.toDouble(),
      availableNumber: json['availableNumber'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isAvailable: json['isAvailable'],
      businessOwnerId: json['businessOwnerId'],
      images:
          json['images'] != null
              ? (json['images'] as List)
                  .map(
                    (img) => DestinationImage(
                      imageId: img['imageId'] ?? '',
                      imageUrl: img['imageBase64'] ?? '',
                    ),
                  )
                  .toList()
              : null,
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
