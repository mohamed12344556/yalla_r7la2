import 'package:yalla_r7la2/core/themes/booking_constants.dart';

class BookingUtils {
  /// Get day name from weekday number
  static String getDayName(int weekday) {
    return BookingConstants.weekDays[weekday - 1];
  }

  /// Format date as dd/mm/yyyy
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Calculate total price with taxes
  static double calculateTotalPrice(double basePrice, int passengers) {
    final subtotal = basePrice * passengers;
    final taxes = subtotal * BookingConstants.taxRate;
    return subtotal + taxes;
  }

  /// Calculate taxes amount
  static double calculateTaxes(double basePrice, int passengers) {
    return (basePrice * passengers) * BookingConstants.taxRate;
  }

  /// Calculate subtotal without taxes
  static double calculateSubtotal(double basePrice, int passengers) {
    return basePrice * passengers;
  }

  /// Validate passenger count
  static bool isValidPassengerCount(int passengers) {
    return passengers >= BookingConstants.minPassengers &&
        passengers <= BookingConstants.maxPassengers;
  }

  /// Get passenger text (singular/plural)
  static String getPassengerText(int passengers) {
    return passengers == 1 ? 'person' : 'people';
  }

  /// Get passenger label text
  static String getPassengerLabel(int passengers) {
    return passengers == 1 ? 'Passenger' : 'Passengers';
  }

  /// Validate date selection
  static bool isValidDateSelection(DateTime departure, DateTime returnDate) {
    return returnDate.isAfter(departure);
  }

  /// Calculate trip duration in days
  static int calculateTripDuration(DateTime departure, DateTime returnDate) {
    return returnDate.difference(departure).inDays;
  }

  /// Generate booking ID (mock implementation)
  static String generateBookingId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'BK${timestamp.toString().substring(8)}';
  }

  /// Check if booking is upcoming
  static bool isUpcomingBooking(DateTime departureDate) {
    return departureDate.isAfter(DateTime.now());
  }

  /// Check if booking is past
  static bool isPastBooking(DateTime returnDate) {
    return returnDate.isBefore(DateTime.now());
  }

  /// Truncate booking ID for display
  static String truncateBookingId(String bookingId, {int maxLength = 8}) {
    if (bookingId.length <= maxLength) return bookingId;
    return '${bookingId.substring(0, maxLength)}...';
  }

  /// Get default dates for new booking
  static Map<String, DateTime> getDefaultBookingDates() {
    final now = DateTime.now();
    return {
      'departure': now.add(const Duration(days: 7)),
      'return': now.add(const Duration(days: 10)),
    };
  }

  /// Validate minimum stay duration
  static bool hasMinimumStay(
    DateTime departure,
    DateTime returnDate, {
    int minDays = 1,
  }) {
    return calculateTripDuration(departure, returnDate) >= minDays;
  }
}
