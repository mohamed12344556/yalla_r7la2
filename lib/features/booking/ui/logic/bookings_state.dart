part of 'bookings_cubit.dart';

@immutable
abstract class BookingsState {}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<BookingModel> bookings;

  BookingsLoaded(this.bookings);
}

class BookingsError extends BookingsState {
  final String message;

  BookingsError(this.message);
}

class BookingAdded extends BookingsState {
  final BookingModel booking;
  final int remainingSlots;

  BookingAdded(this.booking, this.remainingSlots);
}

class BookingCancelled extends BookingsState {
  final String bookingId;
  final int availableSlots;

  BookingCancelled(this.bookingId, this.availableSlots);
}

class BookingDeleted extends BookingsState {
  final String bookingId;

  BookingDeleted(this.bookingId);
}
