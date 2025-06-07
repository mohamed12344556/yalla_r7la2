import 'package:flutter/material.dart';
import 'package:yalla_r7la2/core/themes/booking_constants.dart';
import 'package:yalla_r7la2/features/booking/data/models/booking_models.dart';

import 'booking_date_helper.dart';
import 'booking_status_helper.dart';

class BookingDetailsSheet extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsSheet({super.key, required this.booking});

  static void show({
    required BuildContext context,
    required BookingModel booking,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingDetailsSheet(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BookingConstants.topRadius,
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: BookingConstants.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDestinationInfo(),
                  const SizedBox(height: 24),
                  _buildTravelDates(),
                  const SizedBox(height: 24),
                  _buildFlightDetails(),
                  const SizedBox(height: 24),
                  _buildPassengerInfo(),
                  const SizedBox(height: 24),
                  _buildPriceBreakdown(),
                  const SizedBox(height: 24),
                  _buildBookingInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: BookingConstants.primaryGradient,
        borderRadius: BookingConstants.topRadius,
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Booking Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking ID',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    booking.bookingId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              BookingStatusHelper.buildStatusChip(booking.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationInfo() {
    return _buildSection(
      title: 'Destination',
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              booking.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.destinationName,
                  style: BookingConstants.subtitleStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  booking.destinationLocation,
                  style: BookingConstants.captionStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  '${BookingDateHelper.calculateTripDuration(booking.departureDate, booking.returnDate)} days trip',
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelDates() {
    return _buildSection(
      title: 'Travel Dates',
      child: Row(
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
    );
  }

  Widget _buildFlightDetails() {
    return _buildSection(
      title: 'Flight Information',
      child: Column(
        children: [
          _buildFlightRow(
            'Outbound Flight',
            booking.departureTime,
            booking.returnDepartureTime,
            BookingConstants.defaultFlightDuration,
            Icons.flight_takeoff,
          ),
          const Divider(height: 24),
          _buildFlightRow(
            'Return Flight',
            booking.returnDepartureTime,
            booking.returnArrivalTime,
            BookingConstants.defaultFlightDuration,
            Icons.flight_land,
          ),
        ],
      ),
    );
  }

  Widget _buildFlightRow(
    String title,
    String departureTime,
    String arrivalTime,
    String duration,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    departureTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(' → '),
                  Text(
                    arrivalTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(duration, style: BookingConstants.captionStyle),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerInfo() {
    return _buildSection(
      title: 'Passenger Information',
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Text(
            '${booking.passengers} ${booking.passengers == 1 ? 'Passenger' : 'Passengers'}',
            style: BookingConstants.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    final subtotal = booking.totalAmount / (1 + BookingConstants.taxRate);
    final taxes = booking.totalAmount - subtotal;

    return _buildSection(
      title: 'Price Breakdown',
      child: Column(
        children: [
          _buildPriceRow(
            'Base Price',
            '${booking.passengers} × \$${(subtotal / booking.passengers).toStringAsFixed(0)}',
            '\$${subtotal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 12),
          _buildPriceRow(
            'Taxes & Fees',
            '${(BookingConstants.taxRate * 100).toInt()}%',
            '\$${taxes.toStringAsFixed(0)}',
          ),
          const Divider(height: 24),
          _buildPriceRow(
            'Total Amount',
            '',
            '\$${booking.totalAmount.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingInfo() {
    return _buildSection(
      title: 'Booking Information',
      child: Column(
        children: [
          _buildInfoRow(
            'Booking Date',
            booking.formattedBookingDate,
            Icons.calendar_today,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Booking ID',
            booking.bookingId,
            Icons.confirmation_number,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Status',
            BookingStatusHelper.getStatusText(booking.status),
            Icons.info_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: BookingConstants.subtitleStyle),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: BookingConstants.cardPadding,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BookingConstants.cardRadius,
            border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String title,
    String subtitle,
    String price, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: isTotal ? Colors.blueAccent : Colors.black87,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(subtitle, style: BookingConstants.captionStyle),
          ],
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.blueAccent : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueAccent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: BookingConstants.captionStyle),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
