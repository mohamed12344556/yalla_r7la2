import 'package:flutter/material.dart';
import 'package:yalla_r7la2/core/routes/routes.dart';
import 'package:yalla_r7la2/features/booking/data/models/booking_models.dart';

import 'booking_card.dart';
import 'booking_empty_state.dart';

class BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  final String tabName;
  final Future<void> Function()? onRefresh;

  const BookingList({
    super.key,
    required this.bookings,
    required this.tabName,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      color: Colors.blueAccent,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return BookingCard(booking: bookings[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    String message = 'No bookings found';
    String subMessage = 'Your bookings will appear here';
    IconData icon = Icons.flight_takeoff;

    if (tabName.contains('Upcoming')) {
      message = 'No upcoming trips';
      subMessage = 'Plan your next adventure!';
      icon = Icons.upcoming;
    } else if (tabName.contains('Past')) {
      message = 'No past trips';
      subMessage = 'Your travel history will appear here';
      icon = Icons.history;
    }

    return BookingEmptyState(
      message: message,
      subMessage: subMessage,
      icon: icon,
      onActionPressed: () => Navigator.of(context).pushNamed(Routes.host),
    );
  }
}
