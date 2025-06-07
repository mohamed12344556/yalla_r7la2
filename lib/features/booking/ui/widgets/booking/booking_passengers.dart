import 'package:flutter/material.dart';
import 'package:yalla_r7la2/core/themes/booking_constants.dart';

class BookingPassengers extends StatelessWidget {
  final int passengers;
  final ValueChanged<int> onPassengersChanged;

  const BookingPassengers({
    super.key,
    required this.passengers,
    required this.onPassengersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Passengers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.person, color: Colors.blueAccent, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Number of Passengers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: passengers > BookingConstants.minPassengers
                        ? () => onPassengersChanged(passengers - 1)
                        : null,
                    icon: Icon(
                      Icons.remove_circle,
                      color: passengers > BookingConstants.minPassengers 
                          ? Colors.blueAccent 
                          : Colors.grey,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      passengers.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: passengers < BookingConstants.maxPassengers
                        ? () => onPassengersChanged(passengers + 1)
                        : null,
                    icon: Icon(
                      Icons.add_circle,
                      color: passengers < BookingConstants.maxPassengers 
                          ? Colors.blueAccent 
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}