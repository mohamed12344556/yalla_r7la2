import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'auth_repo.dart';

import '../../../../core/api/api_constants.dart';
import '../models/forgot_password_model.dart';

extension AuthRepoForgotPassword on AuthRepo {
  // Forgot Password method
  Future<Either<String, ForgotPasswordResponse>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.resetPassword}/$email/$newPassword',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Right(ForgotPasswordResponse.fromJson(data));
      } else {
        return Left('Reset password failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        // Extract specific error messages from the API response
        final errorData = e.response?.data;
        if (errorData != null && errorData['message'] != null) {
          return Left(errorData['message']);
        }
        return Left('Reset password failed: ${e.response?.statusCode}');
      }
      return Left('Network error: $e');
    }
  }
}
