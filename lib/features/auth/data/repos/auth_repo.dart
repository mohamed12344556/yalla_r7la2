import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/api_constants.dart';
import '../models/auth_model.dart';

class AuthRepo {
  final Dio dio;

  AuthRepo({required this.dio});

  // Auth Services
  Future<Either<String, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Right(AuthResponse.fromJson(data));
      } else {
        return Left('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, AuthResponse>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String dateOfBirth,
    required String password,
    required String city,
    required String prefrance,
    String? imagePath, // Changed to imagePath instead of imageData
    String? uniqueIdImage,
  }) async {
    try {
      // Create FormData object
      final FormData formData = FormData.fromMap({
        'Name': fullName,
        'Email': email,
        'PhoneNumper': phoneNumber, // Note: keeping API's original spelling
        'dateOfBirth': dateOfBirth,
        'Password': password,
        'City': city,
        'Prefrance': prefrance,
      });

      // Add image file if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(
          MapEntry('ImageData', await MultipartFile.fromFile(imagePath)),
        );
      } else {
        // If no image is provided, add an empty file or handle as required by API
        formData.fields.add(MapEntry('ImageData', ''));
      }

      // Add optional unique image ID if provided
      if (uniqueIdImage != null) {
        formData.fields.add(MapEntry('uniqueIdImage', uniqueIdImage));
      }

      final response = await dio.post(
        ApiConstants.signup,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        return Right(AuthResponse.fromJson(data));
      } else {
        return Left('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        // Extract specific error messages from the API response
        final errorData = e.response?.data;
        if (errorData != null && errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          final errorList = <String>[];

          errors.forEach((field, messages) {
            if (messages is List) {
              errorList.addAll(messages.cast<String>());
            }
          });

          return Left(errorList.join(', '));
        }
        return Left('Registration failed: ${e.response?.statusCode}');
      }
      return Left('Network error: $e');
    }
  }

  // forgot password
}
