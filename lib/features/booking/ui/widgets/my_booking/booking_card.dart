import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/features/booking/data/models/booking_models.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking_dialogs.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/my_booking/booking_date_helper.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/my_booking/booking_status_helper.dart';

import '../../logic/bookings_cubit.dart';
import 'booking_details_sheet.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: [_buildHeader(context), _buildBody(context)]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        image: DecorationImage(
          image: MemoryImage(booking.imageBytes!),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            // Handle image loading error
            print('Error loading booking image: $exception');
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.destinationName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          booking.destinationLocation,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  BookingStatusHelper.buildStatusChip(booking.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Booking ID and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking ID: ${_truncateBookingId(booking.bookingId)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Booked: ${booking.formattedBookingDate}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Travel dates
          Row(
            children: [
              Expanded(
                child: BookingDateHelper.buildDateInfo(
                  'Departure',
                  booking.formattedDepartureDate,
                  booking.departureTime,
                  Icons.flight_takeoff,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BookingDateHelper.buildDateInfo(
                  'Return',
                  booking.formattedReturnDate,
                  booking.returnArrivalTime,
                  Icons.flight_land,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Passengers and price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.blueAccent),
                  const SizedBox(width: 4),
                  Text(
                    '${booking.passengers} ${booking.passengers == 1 ? 'Passenger' : 'Passengers'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${booking.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (booking.status == BookingStatus.confirmed) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showCancelDialog(context),
              icon: const Icon(Icons.cancel, size: 16),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showBookingDetails(context),
              icon: const Icon(Icons.info, size: 16),
              label: const Text('Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    if (booking.status == BookingStatus.cancelled) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showDeleteDialog(context),
          icon: const Icon(Icons.delete, size: 16),
          label: const Text('Delete'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showCancelDialog(BuildContext context) {
    BookingDialogs.showCancelDialog(
      context: context,
      booking: booking,
      onConfirm: () {
        context.read<BookingsCubit>().cancelBooking(booking.bookingId);
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    BookingDialogs.showDeleteDialog(
      context: context,
      booking: booking,
      onConfirm: () {
        context.read<BookingsCubit>().deleteBooking(booking.bookingId);
      },
    );
  }

  void _showBookingDetails(BuildContext context) {
    BookingDetailsSheet.show(context: context, booking: booking);
  }

  String _truncateBookingId(String bookingId) {
    return bookingId.length > 8 ? '${bookingId.substring(0, 8)}...' : bookingId;
  }
}
