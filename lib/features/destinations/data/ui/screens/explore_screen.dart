import 'package:flutter/material.dart';
import 'flight_booking_screen.dart';

import 'DescriptionScreen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // List of destination images and names
  final List<Map<String, dynamic>> _destinations = [
    {
      'image': 'https://images.unsplash.com/photo-1517935706615-2717063c2225',
      'name': 'Toronto, Canada',
      'distance': '12.5 km',
      'discription': 'A city in Canada',
    },
    {
      'image': 'https://images.unsplash.com/photo-1602940659805-770d1b3b9911',
      'name': 'New York, USA',
      'distance': '347 km',
      'discription': 'A city in USA',
    },
    {
      'image': 'https://images.unsplash.com/photo-1549144511-f099e773c147',
      'name': 'Paris, France',
      'distance': '5,840 km',
      'discription': 'A city in France',
    },
    {
      'image': 'https://images.unsplash.com/photo-1493780474015-ba834fd0ce2f',
      'name': 'London, UK',
      'distance': '5,550 km',
      'discription': 'A city in UK',
    },
    {
      'image': 'https://images.unsplash.com/photo-1545893835-1cc3d62e494d',
      'name': 'Dubai, UAE',
      'distance': '11,023 km',
      'discription': 'A city in UAE',
    },
  ];
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    color: Colors.teal,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  _destinations.length,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color:
                            index == _currentPage
                                ? Colors.teal
                                : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Scrollable destination images with tap to go to description
            SizedBox(
              height: 240,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _destinations.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Pass the selected image URL to the DescriptionScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DescriptionScreen(
                                imageUrl: _destinations[index]['image'],
                              ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(_destinations[index]['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 16,
                            bottom: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _destinations[index]['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _destinations[index]['distance'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Map section - taking all remaining space
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Full map image with all markers included
                  Image.asset('assets/download.png', fit: BoxFit.cover),

                  // Start button overlay to navigate to booking screen
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BookingScreen(
                                  location: _destinations[_currentPage],
                                ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
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
