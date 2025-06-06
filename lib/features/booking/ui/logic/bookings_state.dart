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

  BookingAdded(this.booking);
}

class BookingCancelled extends BookingsState {
  final String bookingId;

  BookingCancelled(this.bookingId);
}

class BookingDeleted extends BookingsState {
  final String bookingId;

  BookingDeleted(this.bookingId);
}
