import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/core/cache/shared_pref_helper.dart';
import 'package:yalla_r7la2/features/booking/data/models/booking_models.dart';
import 'package:yalla_r7la2/features/home/data/model/destination_model.dart';

part 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  static const String _bookingsKey = 'user_bookings';
  List<BookingModel> _bookings = [];

  BookingsCubit() : super(BookingsInitial()) {
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

  // Add new booking
  Future<void> addBooking({
    required DestinationModel destination,
    required int passengers,
    required DateTime departureDate,
    required DateTime returnDate,
  }) async {
    try {
      emit(BookingsLoading());

      final newBooking = BookingModel.fromDestination(
        destinationId: destination.destinationId,
        destinationName: destination.name,
        destinationLocation: destination.location,
        imageUrl: destination.imageUrl,
        price: destination.price,
        passengers: passengers,
        departureDate: departureDate,
        returnDate: returnDate,
      );

      _bookings.insert(0, newBooking); // Add to beginning
      await _saveBookings();

      emit(BookingsLoaded(_bookings));
      emit(BookingAdded(newBooking));
    } catch (e) {
      debugPrint('Error adding booking: $e');
      emit(BookingsError('Failed to add booking: ${e.toString()}'));
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      emit(BookingsLoading());

      final bookingIndex = _bookings.indexWhere(
        (b) => b.bookingId == bookingId,
      );
      if (bookingIndex != -1) {
        _bookings[bookingIndex] = _bookings[bookingIndex].copyWith(
          status: BookingStatus.cancelled,
        );
        await _saveBookings();
        emit(BookingsLoaded(_bookings));
        emit(BookingCancelled(bookingId));
      } else {
        emit(BookingsError('Booking not found'));
      }
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      emit(BookingsError('Failed to cancel booking: ${e.toString()}'));
    }
  }

  // Delete booking completely
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

  // Update booking status
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

  // Clear all bookings
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
}
