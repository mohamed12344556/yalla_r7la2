import 'package:flutter/material.dart';
import 'package:yalla_r7la2/core/utils/booking_utils.dart';

class BookingTravelDates extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime returnDate;
  final Function(DateTime selectedDate, DateTime returnDate) onDateSelected;

  const BookingTravelDates({
    super.key,
    required this.selectedDate,
    required this.returnDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Travel Dates',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateCard(
                context,
                'Departure',
                selectedDate,
                Icons.flight_takeoff,
                () => _selectDate(context, true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateCard(
                context,
                'Return',
                returnDate,
                Icons.flight_land,
                () => _selectDate(context, false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateCard(
    BuildContext context,
    String title,
    DateTime date,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              BookingUtils.formatDate(date),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              BookingUtils.getDayName(date.weekday),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeparture ? selectedDate : returnDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      DateTime newSelectedDate = selectedDate;
      DateTime newReturnDate = returnDate;

      if (isDeparture) {
        newSelectedDate = picked;
        // Ensure return date is after departure date
        if (returnDate.isBefore(newSelectedDate.add(const Duration(days: 1)))) {
          newReturnDate = newSelectedDate.add(const Duration(days: 3));
        }
      } else {
        newReturnDate = picked;
      }

      onDateSelected(newSelectedDate, newReturnDate);
    }
  }
}