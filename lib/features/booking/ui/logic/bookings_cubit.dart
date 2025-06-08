import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/core/cache/shared_pref_helper.dart';
import 'package:yalla_r7la2/features/booking/data/models/booking_models.dart';
import 'package:yalla_r7la2/features/booking/data/repos/booking_repo.dart';
import 'package:yalla_r7la2/features/home/data/model/destination_model.dart';

part 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  static const String _bookingsKey = 'user_bookings';
  List<BookingModel> _bookings = [];
  final BookingRepo _bookingRepo;

  BookingsCubit({required BookingRepo bookingRepo})
    : _bookingRepo = bookingRepo,
      super(BookingsInitial()) {
    loadBookings();
  }

  List<BookingModel> get bookings => List.unmodifiable(_bookings);

  // Load bookings from local storage
  Future<void> loadBookings() async {
    try {
      emit(BookingsLoading());

      final bookingsJson = await SharedPrefHelper.getString(_bookingsKey);

      if (bookingsJson.isNotEmpty) {
        final List<dynamic> bookingsList = jsonDecode(bookingsJson);
        _bookings =
            bookingsList.map((json) => BookingModel.fromJson(json)).toList();

        // Sort by booking date (newest first)
        _bookings.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
      }

      emit(BookingsLoaded(_bookings));
    } catch (e) {
      debugPrint('Error loading bookings: $e');
      emit(BookingsError('Failed to load bookings: ${e.toString()}'));
    }
  }

  // Add new booking with API integration
  Future<void> addBooking({
    required DestinationModel destination,
    required int passengers,
    required DateTime departureDate,
    required DateTime returnDate,
  }) async {
    try {
      emit(BookingsLoading());

      // Call API to book destination
      final bookingResult = await _bookingRepo.bookDestination(
        destination.destinationId,
      );

      bookingResult.fold(
        (error) {
          // Left side - error occurred
          debugPrint('Booking API error: $error');
          emit(BookingsError('Failed to book destination: $error'));
        },
        (bookingResponse) async {
          // Right side - success
          try {
            final newBooking = BookingModel.fromDestination(
              destinationId: destination.destinationId,
              destinationName: destination.name,
              destinationLocation: destination.location ?? 'Unknown Location',
              imageUrl: destination.imageUrl,
              price: destination.price,
              passengers: passengers,
              departureDate: departureDate,
              returnDate: returnDate,
            );

            _bookings.insert(0, newBooking); // Add to beginning
            await _saveBookings();

            emit(BookingsLoaded(_bookings));
            emit(BookingAdded(newBooking, bookingResponse.remainingSlots));
          } catch (e) {
            debugPrint('Error saving booking locally: $e');
            emit(
              BookingsError('Booking successful but failed to save locally'),
            );
          }
        },
      );
    } catch (e) {
      debugPrint('Error adding booking: $e');
      emit(BookingsError('Failed to add booking: ${e.toString()}'));
    }
  }

  // Cancel booking with API integration
  Future<void> cancelBooking(String bookingId) async {
    try {
      emit(BookingsLoading());

      final bookingIndex = _bookings.indexWhere(
        (b) => b.bookingId == bookingId,
      );
      if (bookingIndex == -1) {
        emit(BookingsError('Booking not found'));
        return;
      }

      final booking = _bookings[bookingIndex];

      // Call API to unbook destination
      final unbookingResult = await _bookingRepo.unbookDestination(
        booking.destinationId,
      );

      unbookingResult.fold(
        (error) {
          // Left side - error occurred
          debugPrint('Unbooking API error: $error');
          emit(BookingsError('Failed to cancel booking: $error'));
        },
        (unbookingResponse) async {
          // Right side - success
          try {
            _bookings[bookingIndex] = booking.copyWith(
              status: BookingStatus.cancelled,
            );
            await _saveBookings();
            emit(BookingsLoaded(_bookings));
            emit(BookingCancelled(bookingId, unbookingResponse.availableSlots));
          } catch (e) {
            debugPrint('Error updating booking locally: $e');
            emit(
              BookingsError(
                'Cancellation successful but failed to update locally',
              ),
            );
          }
        },
      );
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      emit(BookingsError('Failed to cancel booking: ${e.toString()}'));
    }
  }

  // Delete booking completely (local only - no API call needed)
  Future<void> deleteBooking(String bookingId) async {
    try {
      emit(BookingsLoading());

      _bookings.removeWhere((booking) => booking.bookingId == bookingId);
      await _saveBookings();

      emit(BookingsLoaded(_bookings));
      emit(BookingDeleted(bookingId));
    } catch (e) {
      debugPrint('Error deleting booking: $e');
      emit(BookingsError('Failed to delete booking: ${e.toString()}'));
    }
  }

  // Re-book a cancelled booking
  Future<void> rebookDestination(String bookingId) async {
    try {
      emit(BookingsLoading());

      final bookingIndex = _bookings.indexWhere(
        (b) => b.bookingId == bookingId,
      );
      if (bookingIndex == -1) {
        emit(BookingsError('Booking not found'));
        return;
      }

      final booking = _bookings[bookingIndex];

      // Call API to book destination again
      final bookingResult = await _bookingRepo.bookDestination(
        booking.destinationId,
      );

      bookingResult.fold(
        (error) {
          // Left side - error occurred
          debugPrint('Re-booking API error: $error');
          emit(BookingsError('Failed to re-book destination: $error'));
        },
        (bookingResponse) async {
          // Right side - success
          try {
            _bookings[bookingIndex] = booking.copyWith(
              status: BookingStatus.confirmed,
              bookingDate: DateTime.now(), // Update booking date
            );
            await _saveBookings();
            emit(BookingsLoaded(_bookings));
            emit(BookingAdded(booking, bookingResponse.remainingSlots));
          } catch (e) {
            debugPrint('Error updating booking locally: $e');
            emit(
              BookingsError(
                'Re-booking successful but failed to update locally',
              ),
            );
          }
        },
      );
    } catch (e) {
      debugPrint('Error re-booking: $e');
      emit(BookingsError('Failed to re-book destination: ${e.toString()}'));
    }
  }

  // Update booking status (local only)
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    try {
      final bookingIndex = _bookings.indexWhere(
        (b) => b.bookingId == bookingId,
      );
      if (bookingIndex != -1) {
        _bookings[bookingIndex] = _bookings[bookingIndex].copyWith(
          status: status,
        );
        await _saveBookings();
        emit(BookingsLoaded(_bookings));
      }
    } catch (e) {
      debugPrint('Error updating booking status: $e');
      emit(BookingsError('Failed to update booking: ${e.toString()}'));
    }
  }

  // Get bookings by status
  List<BookingModel> getBookingsByStatus(BookingStatus status) {
    return _bookings.where((booking) => booking.status == status).toList();
  }

  // Get upcoming bookings
  List<BookingModel> getUpcomingBookings() {
    final now = DateTime.now();
    return _bookings
        .where(
          (booking) =>
              booking.departureDate.isAfter(now) &&
              booking.status == BookingStatus.confirmed,
        )
        .toList();
  }

  // Get past bookings
  List<BookingModel> getPastBookings() {
    final now = DateTime.now();
    return _bookings
        .where(
          (booking) =>
              booking.returnDate.isBefore(now) ||
              booking.status == BookingStatus.completed,
        )
        .toList();
  }

  // Check if destination is already booked
  bool isDestinationBooked(String destinationId) {
    return _bookings.any(
      (booking) =>
          booking.destinationId == destinationId &&
          booking.status == BookingStatus.confirmed,
    );
  }

  // Get booking by ID
  BookingModel? getBookingById(String bookingId) {
    try {
      return _bookings.firstWhere((booking) => booking.bookingId == bookingId);
    } catch (e) {
      return null;
    }
  }

  // Clear all bookings (local only)
  Future<void> clearAllBookings() async {
    try {
      emit(BookingsLoading());
      _bookings.clear();
      await SharedPrefHelper.removeData(_bookingsKey);
      emit(BookingsLoaded(_bookings));
    } catch (e) {
      debugPrint('Error clearing bookings: $e');
      emit(BookingsError('Failed to clear bookings: ${e.toString()}'));
    }
  }

  // Save bookings to local storage
  Future<void> _saveBookings() async {
    try {
      final bookingsJson = jsonEncode(
        _bookings.map((booking) => booking.toJson()).toList(),
      );
      await SharedPrefHelper.setData(_bookingsKey, bookingsJson);
    } catch (e) {
      debugPrint('Error saving bookings: $e');
      throw Exception('Failed to save bookings');
    }
  }

  // Get statistics
  Map<String, dynamic> getBookingStats() {
    final confirmed =
        _bookings.where((b) => b.status == BookingStatus.confirmed).length;
    final cancelled =
        _bookings.where((b) => b.status == BookingStatus.cancelled).length;
    final completed =
        _bookings.where((b) => b.status == BookingStatus.completed).length;
    final totalSpent = _bookings
        .where((b) => b.status != BookingStatus.cancelled)
        .fold<double>(0, (sum, booking) => sum + booking.totalAmount);

    return {
      'total': _bookings.length,
      'confirmed': confirmed,
      'cancelled': cancelled,
      'completed': completed,
      'totalSpent': totalSpent,
    };
  }

  // Refresh bookings (useful for pull-to-refresh)
  Future<void> refreshBookings() async {
    await loadBookings();
  }

  // Check for booking conflicts before adding
  bool hasBookingConflict({
    required String destinationId,
    required DateTime departureDate,
    required DateTime returnDate,
  }) {
    return _bookings.any((booking) {
      if (booking.destinationId != destinationId ||
          booking.status == BookingStatus.cancelled) {
        return false;
      }

      // Check for date overlap
      return (departureDate.isBefore(booking.returnDate) &&
          returnDate.isAfter(booking.departureDate));
    });
  }

  // Get total amount spent
  double getTotalAmountSpent() {
    return _bookings
        .where((b) => b.status != BookingStatus.cancelled)
        .fold<double>(0, (sum, booking) => sum + booking.totalAmount);
  }

  // Get bookings for a specific destination
  List<BookingModel> getBookingsForDestination(String destinationId) {
    return _bookings
        .where((booking) => booking.destinationId == destinationId)
        .toList();
  }
}
