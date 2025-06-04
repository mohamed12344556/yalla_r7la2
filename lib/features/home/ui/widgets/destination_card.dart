import 'package:flutter/material.dart';
import '../../data/model/destination_model.dart';
import '../screens/destination_details_screen.dart';
import 'destination_card_content.dart';

class DestinationCard extends StatelessWidget {
  final DestinationModel cardData;
  const DestinationCard({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DestinationDetailsScreen(card: cardData),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        shadowColor: Colors.black12,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blueAccent, width: 3),
        ),
        child: DestinationCardContent(cardData: cardData),
      ),
    );
  }
}
