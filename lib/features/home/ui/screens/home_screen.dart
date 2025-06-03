import 'package:flutter/material.dart';
import 'package:p1/features/home/ui/widgets/home_header.dart';
import 'package:p1/features/home/ui/widgets/search_and_categories_section.dart';
import 'package:p1/features/home/ui/widgets/top_destinations_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with location and notifications
            const SliverToBoxAdapter(child: HomeHeader()),

            // Search and Categories
            const SliverToBoxAdapter(child: SearchAndCategoriesSection()),

            // Top Destinations
            const SliverToBoxAdapter(child: TopDestinationsSection()),

            // // Events Section
            // const SliverToBoxAdapter(child: EventsSection()),

            // Add some bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
