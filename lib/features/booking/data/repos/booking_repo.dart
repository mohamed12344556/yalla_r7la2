import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/cache/shared_pref_helper.dart';

class BookingRepo {
  final Dio dio;

  BookingRepo({required this.dio});

  /// Get authorization headers with token
  Future<Map<String, dynamic>> _getAuthHeaders() async {
    final token = await SharedPrefHelper.getString('auth_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// Book a destination
  Future<Either<String, BookingResponse>> bookDestination(
    String destinationId,
  ) async {
    try {
      final headers = await _getAuthHeaders();

      final response = await dio.post(
        '${ApiConstants.bookDestination}/$destinationId',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bookingResponse = BookingResponse.fromJson(response.data);
        return Right(bookingResponse);
      } else {
        return Left(_handleErrorResponse(response));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Unbook a destination
  Future<Either<String, UnbookingResponse>> unbookDestination(
    String destinationId,
  ) async {
    try {
      final headers = await _getAuthHeaders();

      final response = await dio.delete(
        '${ApiConstants.unbookDestination}/$destinationId',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final unbookingResponse = UnbookingResponse.fromJson(response.data);
        return Right(unbookingResponse);
      } else {
        return Left(_handleErrorResponse(response));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Handle error responses
  String _handleErrorResponse(Response response) {
    switch (response.statusCode) {
      case 400:
        return 'Invalid booking request. Please check your data.';
      case 401:
        return 'Authentication failed. Please login again.';
      case 403:
        return 'You don\'t have permission to perform this action.';
      case 404:
        return 'Destination not found.';
      case 409:
        return 'Booking conflict. Destination might be fully booked.';
      case 422:
        return 'Invalid booking data provided.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Booking failed. Please try again.';
    }
  }

  /// Handle Dio exceptions
  String _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case DioExceptionType.badResponse:
        if (e.response?.data != null && e.response?.data['message'] != null) {
          return e.response!.data['message'];
        }
        return _handleErrorResponse(e.response!);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }
}

/// Response model for booking API
class BookingResponse {
  final String message;
  final int remainingSlots;

  BookingResponse({required this.message, required this.remainingSlots});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      message: json['message'] ?? 'Booking successful',
      remainingSlots: json['remainingSlots'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'remainingSlots': remainingSlots};
  }
}

/// Response model for unbooking API
class UnbookingResponse {
  final String message;
  final int availableSlots;

  UnbookingResponse({required this.message, required this.availableSlots});

  factory UnbookingResponse.fromJson(Map<String, dynamic> json) {
    return UnbookingResponse(
      message: json['message'] ?? 'Unbooking successful',
      availableSlots: json['availableSlots'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'availableSlots': availableSlots};
  }
}
