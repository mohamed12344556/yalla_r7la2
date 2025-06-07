import 'package:flutter/material.dart';
import 'package:yalla_r7la2/core/themes/booking_constants.dart';
import 'package:yalla_r7la2/features/home/data/model/destination_model.dart';



class BookingFlightDetails extends StatelessWidget {
  final DestinationModel destination;

  const BookingFlightDetails({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Flight Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Outbound Flight
              _buildFlightRoute(
                'Outbound Flight',
                'Cairo, Egypt',
                destination.location ?? 'Unknown Location',
                BookingConstants.defaultDepartureTime,
                BookingConstants.defaultArrivalTime,
                BookingConstants.defaultFlightDuration,
                true,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              // Return Flight
              _buildFlightRoute(
                'Return Flight',
                destination.location ?? 'Unknown Location',
                'Cairo, Egypt',
                BookingConstants.defaultReturnDepartureTime,
                BookingConstants.defaultReturnArrivalTime,
                BookingConstants.defaultFlightDuration,
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlightRoute(
    String title,
    String from,
    String to,
    String departTime,
    String arriveTime,
    String duration,
    bool isOutbound,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    departTime,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    from,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 2,
                        color: Colors.blueAccent.withOpacity(0.3),
                      ),
                      Transform.rotate(
                        angle:
                            isOutbound
                                ? 0
                                : 3.14159, // Rotate 180 degrees for return
                        child: const Icon(
                          Icons.flight,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Direct',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    arriveTime,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    to,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
