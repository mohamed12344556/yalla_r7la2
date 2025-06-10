import 'package:flutter/material.dart';
import 'package:yalla_r7la2/generated/l10n.dart';
import '../../../data/models/booking_models.dart';

class BookingStatusHelper {
  static Widget buildStatusChip(BuildContext context, BookingStatus status) {
    Color color;
    String text;

    switch (status) {
      case BookingStatus.confirmed:
        color = Colors.green;
        text = S.of(context).Confirmed;
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        text = S.of(context).Cancelled;
        break;
      case BookingStatus.completed:
        color = Colors.blue;
        text = S.of(context).Completed;
        break;
      case BookingStatus.pending:
        color = Colors.orange;
        text = S.of(context).Pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Color getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.pending:
        return Colors.orange;
    }
  }

  static String getStatusText(BuildContext context, BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return S.of(context).Confirmed;
      case BookingStatus.cancelled:
        return S.of(context).Cancelled;
      case BookingStatus.completed:
        return S.of(context).Completed;
      case BookingStatus.pending:
        return S.of(context).Pending;
    }
  }
}
