import 'package:flutter/material.dart';

import '../widgets/home_header.dart';
import '../widgets/search_and_categories_section.dart';
import '../widgets/top_destinations_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 255, 195),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with location and notifications
            const SliverToBoxAdapter(child: HomeHeader()),

            // Search and Categories
            const SliverToBoxAdapter(child: SearchAndCategoriesSection()),

            // Top Destinations
            const SliverToBoxAdapter(child: TopDestinationsSection()),

            // Add some bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
