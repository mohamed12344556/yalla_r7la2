import 'package:dio/dio.dart';

import '../../../../core/api/api_constants.dart';
import '../model/destination_model.dart';

class DestinationRepo {
  final Dio dio;

  DestinationRepo({required this.dio});

  // Get all destinations
  Future<List<DestinationModel>> getAllDestinations() async {
    try {
      final response = await dio.get(ApiConstants.destinations);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // Use fromListJson for list responses as they have limited fields
        // return data.map((json) => DestinationModel.fromListJson(json)).toList();
        return data.map((json) => DestinationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load destinations');
      }
    } catch (e) {
      throw Exception('Error fetching destinations: $e');
    }
  }

  // Get destination details by ID
  Future<DestinationModel> getDestinationDetails(String destinationId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.destinationDetails}/$destinationId',
      );

      if (response.statusCode == 200) {
        // Use regular fromJson for detailed response as it has all fields
        return DestinationModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load destination details');
      }
    } catch (e) {
      throw Exception('Error fetching destination details: $e');
    }
  }

  // Get destinations by category
  Future<List<DestinationModel>> getDestinationsByCategory(
    String category,
  ) async {
    try {
      final response = await dio.get(
        ApiConstants.destinationsByCategory,
        queryParameters: {'category': category},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // Use fromListJson for list responses as they have limited fields
        return data.map((json) => DestinationModel.fromListJson(json)).toList();
      } else {
        throw Exception('Failed to load destinations by category');
      }
    } catch (e) {
      throw Exception('Error fetching destinations by category: $e');
    }
  }
}
