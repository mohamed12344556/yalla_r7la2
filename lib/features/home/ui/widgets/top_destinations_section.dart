import 'package:flutter/material.dart';

import '../../data/model/destination_model.dart';
import 'destination_card.dart';

class TopDestinationsSection extends StatelessWidget {
  final List<DestinationModel> destinations;

  const TopDestinationsSection({super.key, required this.destinations});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Top Trips",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              if (destinations.isNotEmpty)
                Text(
                  "${destinations.length} trips",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (destinations.isEmpty)
            _buildEmptyState()
          else
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: topDestinationsWidget(destinations),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_off_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No trips found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try selecting a different category',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

Widget topDestinationsWidget(List<DestinationModel> items) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: items.length,
    padding: const EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: DestinationCard(cardData: items[index]),
      );
    },
  );
}
