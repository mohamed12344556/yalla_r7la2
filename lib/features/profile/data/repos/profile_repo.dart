import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../core/api/api_constants.dart';
import '../models/user_model.dart';

class ProfileRepo {
  final Dio dio;

  ProfileRepo({required this.dio});

  // Get user profile info
  Future<UserModel> getUserProfile() async {
    try {
      log('Getting user profile...');

      final response = await dio.get(ApiConstants.userProfile);

      if (response.statusCode == 200) {
        log('Profile data received: ${response.data}');
        return UserModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to get user profile: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      log('DioException in getUserProfile: ${e.message}');
      if (e.response != null) {
        log('Error response: ${e.response?.data}');
        throw Exception(
          'Failed to get profile: ${e.response?.data['message'] ?? e.message}',
        );
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Unexpected error in getUserProfile: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  // Update user profile (with or without image) - ALWAYS uses FormData
  Future<UserModel> updateUserProfile({
    required UserModel user,
    File? imageFile,
  }) async {
    try {
      log('Updating user profile with FormData...');

      // Create FormData map first, then convert to FormData
      Map<String, dynamic> formDataMap = {};

      // Add user data fields - تأكد من إضافة جميع الحقول المطلوبة
      if (user.name != null && user.name!.isNotEmpty) {
        formDataMap['Name'] = user.name!;
      }

      if (user.email != null && user.email!.isNotEmpty) {
        formDataMap['Email'] = user.email!;
      }

      if (user.city != null && user.city!.isNotEmpty) {
        formDataMap['City'] = user.city!;
      }

      if (user.preference != null && user.preference!.isNotEmpty) {
        formDataMap['Prefrance'] = user.preference!;
      }

      // إضافة Password (Required) - تأكد من وجودها
      if (user.password != null) {
        formDataMap['Password'] = user.password.toString();
      } else {
        throw Exception('Password is required for profile update');
      }

      // إضافة PhoneNumber (Required) - تأكد من وجودها
      if (user.phoneNumber != null) {
        formDataMap['PhoneNumper'] = user.phoneNumber.toString();
      } else {
        throw Exception('Phone number is required for profile update');
      }

      // Convert age to birthdate if provided
      if (user.age != null) {
        final now = DateTime.now();
        final birthYear = now.year - user.age!;
        final birthDate = DateTime(birthYear, now.month, now.day);
        formDataMap['BirthDate'] = birthDate.toIso8601String();
      }

      // Add image file if provided
      if (imageFile != null) {
        String fileName = imageFile.path.split('/').last;
        if (await imageFile.exists()) {
          formDataMap['ImageData'] = await MultipartFile.fromFile(
            imageFile.path,
            filename: fileName,
          );
        } else {
          throw Exception('Image file does not exist');
        }
      } else {
        throw Exception('Image file is required for profile update');
      }

      // Create FormData from map
      FormData formData = FormData.fromMap(formDataMap);
      log('FormData created with fields: ${formDataMap.keys.toList()}');

      // Create FormData from map
      // FormData formData = FormData.fromMap(formDataMap);

      log('FormData created with fields: ${formDataMap.keys.toList()}');

      final response = await dio.put(
        ApiConstants.editUserProfile,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        log('Profile update response: ${response.data}');

        // Check if response contains user data or just success message
        if (response.data is Map<String, dynamic> &&
                response.data.containsKey('id') ||
            response.data.containsKey('name') ||
            response.data.containsKey('email')) {
          // Response contains user data
          log('Response contains user data, parsing...');
          return UserModel.fromJson(response.data);
        } else {
          // Response doesn't contain user data, fetch updated profile
          log(
            'Response only contains success message, fetching updated profile...',
          );

          // Wait a bit for server to process the update
          await Future.delayed(Duration(milliseconds: 500));

          // Fetch the updated profile
          final updatedProfile = await getUserProfile();
          log('Fetched updated profile after update');
          return updatedProfile;
        }
      } else {
        log('Update failed with status: ${response.statusCode}');
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      log('DioException in updateUserProfile: ${e.message}');
      log('DioException type: ${e.type}');

      if (e.response != null) {
        log('Error response status: ${e.response?.statusCode}');
        log('Error response data: ${e.response?.data}');

        // Handle specific error cases
        if (e.response?.statusCode == 400) {
          throw Exception(
            'Invalid data provided: ${e.response?.data['message'] ?? 'Bad Request'}',
          );
        } else if (e.response?.statusCode == 401) {
          throw Exception('Authentication failed. Please login again.');
        } else if (e.response?.statusCode == 403) {
          throw Exception(
            'Access denied. You don\'t have permission to update this profile.',
          );
        } else if (e.response?.statusCode == 500) {
          throw Exception('Server error occurred. Please try again later.');
        }

        throw Exception(
          'Failed to update profile: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        // Handle network errors
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw Exception(
            'Connection timeout. Please check your internet connection and try again.',
          );
        } else if (e.type == DioExceptionType.connectionError) {
          throw Exception(
            'Connection error. Please check your internet connection.',
          );
        }
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Unexpected error in updateUserProfile: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  // Alternative method: Update and then fetch separately
  Future<UserModel> updateUserProfileAlternative({
    required UserModel user,
    File? imageFile,
  }) async {
    try {
      log('Updating user profile (alternative method)...');

      // First, perform the update
      await _performUpdate(user: user, imageFile: imageFile);

      // Then fetch the updated profile
      log('Update successful, fetching updated profile...');
      return await getUserProfile();
    } catch (e) {
      log('Error in updateUserProfileAlternative: $e');
      rethrow;
    }
  }

  // Helper method to perform the update without expecting user data back
  Future<void> _performUpdate({
    required UserModel user,
    File? imageFile,
  }) async {
    // Create FormData map first, then convert to FormData
    Map<String, dynamic> formDataMap = {};

    // Add user data fields
    if (user.name != null && user.name!.isNotEmpty) {
      formDataMap['Name'] = user.name!;
    }

    if (user.email != null && user.email!.isNotEmpty) {
      formDataMap['Email'] = user.email!;
    }

    if (user.city != null && user.city!.isNotEmpty) {
      formDataMap['City'] = user.city!;
    }

    if (user.preference != null && user.preference!.isNotEmpty) {
      formDataMap['Prefrance'] = user.preference!;
    }

    // Required fields
    if (user.password != null) {
      formDataMap['Password'] = user.password.toString();
    } else {
      throw Exception('Password is required for profile update');
    }

    if (user.phoneNumber != null) {
      formDataMap['PhoneNumper'] = user.phoneNumber.toString();
    } else {
      throw Exception('Phone number is required for profile update');
    }

    // Convert age to birthdate if provided
    if (user.age != null) {
      final now = DateTime.now();
      final birthYear = now.year - user.age!;
      final birthDate = DateTime(birthYear, now.month, now.day);
      formDataMap['BirthDate'] = birthDate.toIso8601String();
    }

    // Add image file if provided
    if (imageFile != null) {
      String fileName = imageFile.path.split('/').last;
      if (await imageFile.exists()) {
        formDataMap['files'] = await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        );
      } else {
        throw Exception('Image file does not exist');
      }
    }

    // Create FormData from map
    FormData formData = FormData.fromMap(formDataMap);

    final response = await dio.put(
      ApiConstants.editUserProfile,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.statusMessage}');
    }

    log('Profile update request completed successfully');
  }

  // Update profile without image (still uses FormData but without image file)
  Future<UserModel> updateUserProfileJson(UserModel user) async {
    // استخدام نفس الدالة ولكن بدون إرسال ملف صورة
    return updateUserProfile(user: user, imageFile: null);
  }

  // Change password using the same endpoint
  Future<UserModel> changePassword({
    required UserModel currentUser,
    required String newPassword,
  }) async {
    try {
      log('Changing password using profile update endpoint...');

      // Create updated user with new password
      final updatedUser = currentUser.copyWith(password: newPassword);

      // Use the same update profile endpoint with new password
      final response = await updateUserProfile(
        user: updatedUser,
        imageFile: null,
      );

      log('Password changed successfully through profile update');
      return response;
    } catch (e) {
      log('Error changing password: $e');
      throw Exception('Failed to change password: $e');
    }
  }
}
