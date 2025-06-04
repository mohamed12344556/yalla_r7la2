import 'package:flutter/material.dart';
import '../../data/model/destination_model.dart';
import 'destination_card.dart';

class TopDestinationsSection extends StatelessWidget {
  const TopDestinationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Trips",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 220, child: topDestinationsWidget(cards)),
        ],
      ),
    );
  }
}

Widget topDestinationsWidget(List<DestinationModel> items) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: items.length,
    padding: const EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, index) {
      return SizedBox(
        width: 300, // Fixed width for each card
        child: DestinationCard(cardData: items[index]),
      );
    },
  );
}
