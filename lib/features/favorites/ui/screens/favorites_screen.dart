import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  final List<Map<String, dynamic>> events = const [
    {
      "title": "Lake",
      "location": "Arizona, USA",
      "price": 90,
      "rating": 4.5,
      "image": "assets/WhatsApp Image 2025-04-17 at 00.17.06_51dc197b.jpg",
    },
    {
      "title": "Eiffel Tower",
      "location": "Paris, France",
      "price": 120,
      "rating": 4.8,
      "image": "assets/visit-the-eiffel-tower.jpg",
    },
    {
      "title": "Pyramids of Giza",
      "location": "Giza, Egypt",
      "price": 75,
      "rating": 4.6,
      "image": "assets/pyramids.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preferences"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Preferences",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Events",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _eventCard(
                title: event["title"],
                location: event["location"],
                price: event["price"].toDouble(),
                rating: event["rating"].toDouble(),
                imagePath: event["image"],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _eventCard({
    required String title,
    required String location,
    required double price,
    required double rating,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                imagePath,
                width: 170.0,
                height: 110.0,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.blueGrey,
                        size: 17,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        location,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "\$$price",
                        style: const TextStyle(color: Colors.cyan),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "per person",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(34),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 4,
                      ),
                      child: Text(
                        "Book Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 29),
            Padding(
              padding: const EdgeInsets.only(top: 9),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.yellow, size: 16),
                  const SizedBox(width: 3),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
