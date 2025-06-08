import 'package:dio/dio.dart';

import '../../../../core/api/api_constants.dart';
import '../model/destination_model.dart';

class SearchRepo {
  final Dio dio;

  SearchRepo({required this.dio});

  // Search destinations by query
  Future<List<DestinationModel>> searchDestinations(String query) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/SearchDestinations', // Adjust endpoint as needed
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => DestinationModel.fromCategoryJson(json))
            .toList();
      } else {
        throw Exception('Failed to search destinations');
      }
    } catch (e) {
      throw Exception('Error searching destinations: $e');
    }
  }

  // Search destinations by location
  Future<List<DestinationModel>> searchByLocation(String location) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/SearchByLocation', // Adjust endpoint as needed
        queryParameters: {'location': location},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => DestinationModel.fromCategoryJson(json))
            .toList();
      } else {
        throw Exception('Failed to search destinations by location');
      }
    } catch (e) {
      throw Exception('Error searching destinations by location: $e');
    }
  }

  // Search destinations by price range
  Future<List<DestinationModel>> searchByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/SearchByPriceRange', // Adjust endpoint as needed
        queryParameters: {'minPrice': minPrice, 'maxPrice': maxPrice},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => DestinationModel.fromCategoryJson(json))
            .toList();
      } else {
        throw Exception('Failed to search destinations by price range');
      }
    } catch (e) {
      throw Exception('Error searching destinations by price range: $e');
    }
  }

  // Advanced search with multiple filters
  Future<List<DestinationModel>> advancedSearch({
    String? query,
    String? category,
    String? location,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? isAvailable,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (query != null && query.isNotEmpty) {
        queryParameters['query'] = query;
      }
      if (category != null && category.isNotEmpty) {
        queryParameters['category'] = category;
      }
      if (location != null && location.isNotEmpty) {
        queryParameters['location'] = location;
      }
      if (minPrice != null) {
        queryParameters['minPrice'] = minPrice;
      }
      if (maxPrice != null) {
        queryParameters['maxPrice'] = maxPrice;
      }
      if (minRating != null) {
        queryParameters['minRating'] = minRating;
      }
      if (isAvailable != null) {
        queryParameters['isAvailable'] = isAvailable;
      }

      final response = await dio.get(
        '${ApiConstants.baseUrl}/AdvancedSearch', // Adjust endpoint as needed
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => DestinationModel.fromCategoryJson(json))
            .toList();
      } else {
        throw Exception('Failed to perform advanced search');
      }
    } catch (e) {
      throw Exception('Error performing advanced search: $e');
    }
  }

  // Get search suggestions/autocomplete
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/SearchSuggestions', // Adjust endpoint as needed
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((suggestion) => suggestion.toString()).toList();
      } else {
        throw Exception('Failed to get search suggestions');
      }
    } catch (e) {
      throw Exception('Error getting search suggestions: $e');
    }
  }

  // Get popular search terms
  Future<List<String>> getPopularSearchTerms() async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/PopularSearchTerms', // Adjust endpoint as needed
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((term) => term.toString()).toList();
      } else {
        throw Exception('Failed to get popular search terms');
      }
    } catch (e) {
      throw Exception('Error getting popular search terms: $e');
    }
  }
}
