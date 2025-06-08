import 'package:dio/dio.dart';

import '../../../../core/api/api_constants.dart';
import '../model/destination_model.dart';

class PaginatedResponse<T> {
  final List<T> data;
  final int totalRecords;
  final int totalPages;
  final int pageNumber;
  final int pageSize;

  PaginatedResponse({
    required this.data,
    required this.totalRecords,
    required this.totalPages,
    required this.pageNumber,
    required this.pageSize,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List).map((item) => fromJsonT(item)).toList(),
      totalRecords: json['totalRecords'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 6,
    );
  }

  bool get hasNextPage => pageNumber < totalPages;
  bool get hasPreviousPage => pageNumber > 1;
}

class DestinationRepo {
  final Dio dio;

  DestinationRepo({required this.dio});

  // Get all destinations with pagination
  Future<PaginatedResponse<DestinationModel>> getAllDestinations({
    int pageNumber = 1,
    int pageSize = 6,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.destinations,
        queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
      );

      if (response.statusCode == 200) {
        return PaginatedResponse.fromJson(
          response.data,
          (json) => DestinationModel.fromListJson(json),
        );
      } else {
        throw Exception('Failed to load destinations');
      }
    } catch (e) {
      throw Exception('Error fetching destinations: $e');
    }
  }

  // Load multiple pages at once (for infinite scroll or load more)
  Future<List<DestinationModel>> loadMultiplePages({
    int startPage = 1,
    int endPage = 1,
    int pageSize = 6,
  }) async {
    List<DestinationModel> allDestinations = [];

    for (int page = startPage; page <= endPage; page++) {
      try {
        final response = await getAllDestinations(
          pageNumber: page,
          pageSize: pageSize,
        );
        allDestinations.addAll(response.data);
      } catch (e) {
        // Break on error, but return what we have so far
        print('Error loading page $page: $e');
        break;
      }
    }

    return allDestinations;
  }

  // Get destination details by ID
  Future<DestinationModel> getDestinationDetails(String destinationId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.destinationDetails}/$destinationId',
      );

      if (response.statusCode == 200) {
        return DestinationModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load destination details');
      }
    } catch (e) {
      throw Exception('Error fetching destination details: $e');
    }
  }

  // Get destinations by category with pagination
  Future<PaginatedResponse<DestinationModel>> getDestinationsByCategory(
    String category, {
    int pageNumber = 1,
    int pageSize = 6,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.destinationsByCategory,
        queryParameters: {
          'category': category,
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        // Check if response has pagination structure
        if (response.data is Map && response.data.containsKey('data')) {
          return PaginatedResponse.fromJson(
            response.data,
            (json) => DestinationModel.fromCategoryJson(json),
          );
        } else {
          // Fallback for non-paginated response
          final List<dynamic> data = response.data;
          return PaginatedResponse<DestinationModel>(
            data:
                data
                    .map((json) => DestinationModel.fromCategoryJson(json))
                    .toList(),
            totalRecords: data.length,
            totalPages: 1,
            pageNumber: 1,
            pageSize: data.length,
          );
        }
      } else {
        throw Exception('Failed to load destinations by category');
      }
    } catch (e) {
      throw Exception('Error fetching destinations by category: $e');
    }
  }

  // Search destinations with pagination
  Future<PaginatedResponse<DestinationModel>> searchDestinations(
    String query, {
    int pageNumber = 1,
    int pageSize = 6,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/SearchDestinations', // Adjust endpoint as needed
        queryParameters: {
          'query': query,
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        return PaginatedResponse.fromJson(
          response.data,
          (json) => DestinationModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to search destinations');
      }
    } catch (e) {
      throw Exception('Error searching destinations: $e');
    }
  }

  // Get image by ID (if you need to fetch images separately)
  Future<String> getImageById(String imageId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/GetImage/$imageId',
        options: Options(
          responseType: ResponseType.plain, // Get as plain text for base64
          receiveTimeout: const Duration(
            seconds: 30,
          ), // Increase timeout for images
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      throw Exception('Error fetching image: $e');
    }
  }

  // Improved method to load images for destinations from GetAllDestinations
  Future<List<DestinationModel>> loadImagesForDestinations(
    List<DestinationModel> destinations,
  ) async {
    if (destinations.isEmpty) return destinations;

    final List<DestinationModel> updatedDestinations = [];
    final List<Future<void>> imageFutures = [];

    // Create a map to store results
    final Map<int, DestinationModel> resultMap = {};

    for (int i = 0; i < destinations.length; i++) {
      final destination = destinations[i];

      if (destination.images != null && destination.images!.isNotEmpty) {
        // Create future for loading images for this destination
        final future = _loadImagesForSingleDestination(
          destination,
          i,
          resultMap,
        );
        imageFutures.add(future);
      } else {
        // No images to load, add directly
        resultMap[i] = destination;
      }
    }

    // Wait for all image loading to complete
    try {
      await Future.wait(imageFutures, eagerError: false);
    } catch (e) {
      print('Some images failed to load: $e');
    }

    // Reconstruct the list in the original order
    for (int i = 0; i < destinations.length; i++) {
      updatedDestinations.add(resultMap[i] ?? destinations[i]);
    }

    return updatedDestinations;
  }

  // Helper method to load images for a single destination
  Future<void> _loadImagesForSingleDestination(
    DestinationModel destination,
    int index,
    Map<int, DestinationModel> resultMap,
  ) async {
    try {
      final List<DestinationImage> updatedImages = [];
      final List<Future<DestinationImage>> imageFutures = [];

      for (final image in destination.images!) {
        if (image.imageBase64.isEmpty) {
          // Create future for loading this image
          final future = _loadSingleImage(image);
          imageFutures.add(future);
        } else {
          // Image already loaded
          updatedImages.add(image);
        }
      }

      // Wait for all images of this destination
      if (imageFutures.isNotEmpty) {
        final loadedImages = await Future.wait(imageFutures, eagerError: false);
        updatedImages.addAll(
          loadedImages.where((img) => img.imageBase64.isNotEmpty),
        );
      }

      // Update the destination with loaded images
      resultMap[index] = destination.copyWith(images: updatedImages);
    } catch (e) {
      print(
        'Failed to load images for destination ${destination.destinationId}: $e',
      );
      // Keep original destination if image loading fails
      resultMap[index] = destination;
    }
  }

  // Helper method to load a single image
  Future<DestinationImage> _loadSingleImage(
    DestinationImage originalImage,
  ) async {
    try {
      final imageData = await getImageById(originalImage.imageId);
      return DestinationImage(
        imageId: originalImage.imageId,
        imageBase64: imageData,
      );
    } catch (e) {
      print('Failed to load image ${originalImage.imageId}: $e');
      return originalImage; // Return original if loading fails
    }
  }

  // Batch load images by IDs (more efficient if supported by API)
  Future<Map<String, String>> getImagesByIds(List<String> imageIds) async {
    if (imageIds.isEmpty) return {};

    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/GetImagesBatch',
        data: {'imageIds': imageIds},
        options: Options(
          receiveTimeout: const Duration(
            seconds: 60,
          ), // Longer timeout for batch
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(key, value.toString()));
      } else {
        throw Exception('Failed to load images batch');
      }
    } catch (e) {
      print(
        'Batch image loading failed, falling back to individual loading: $e',
      );

      // Fallback to individual loading
      final Map<String, String> results = {};
      for (final imageId in imageIds) {
        try {
          final imageData = await getImageById(imageId);
          results[imageId] = imageData;
        } catch (e) {
          print('Failed to load individual image $imageId: $e');
        }
      }
      return results;
    }
  }

  // Optimized method using batch loading if available
  Future<List<DestinationModel>> loadImagesForDestinationsOptimized(
    List<DestinationModel> destinations,
  ) async {
    if (destinations.isEmpty) return destinations;

    // Collect all image IDs that need loading
    final Set<String> imageIdsToLoad = {};

    for (final destination in destinations) {
      if (destination.images != null) {
        for (final image in destination.images!) {
          if (image.imageBase64.isEmpty) {
            imageIdsToLoad.add(image.imageId);
          }
        }
      }
    }

    if (imageIdsToLoad.isEmpty) return destinations;

    // Try to load all images at once
    final imageData = await getImagesByIds(imageIdsToLoad.toList());

    // Update destinations with loaded images
    final List<DestinationModel> updatedDestinations = [];

    for (final destination in destinations) {
      if (destination.images != null && destination.images!.isNotEmpty) {
        final List<DestinationImage> updatedImages = [];

        for (final image in destination.images!) {
          if (image.imageBase64.isEmpty &&
              imageData.containsKey(image.imageId)) {
            updatedImages.add(
              DestinationImage(
                imageId: image.imageId,
                imageBase64: imageData[image.imageId]!,
              ),
            );
          } else {
            updatedImages.add(image);
          }
        }

        updatedDestinations.add(destination.copyWith(images: updatedImages));
      } else {
        updatedDestinations.add(destination);
      }
    }

    return updatedDestinations;
  }
}
