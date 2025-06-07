import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/features/home/ui/widgets/home_header.dart';

import '../logic/home_cubit.dart';
import '../widgets/search_and_categories_section.dart';
import '../widgets/top_destinations_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load destinations when screen initializes
    context.read<HomeCubit>().loadDestinations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF30B0C7)),
                  SizedBox(height: 16),
                  Text(
                    'Loading destinations...',
                    style: TextStyle(color: Color(0xFF666666), fontSize: 16),
                  ),
                ],
              ),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().loadDestinations();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF30B0C7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header with location and notifications
                  const SliverToBoxAdapter(child: HomeHeader()),
                  // Search and Categories Section
                  SliverToBoxAdapter(
                    child: SearchAndCategoriesSection(
                      categories: state.categories,
                      selectedCategory: state.selectedCategory,
                      onCategorySelected: (category) {
                        if (category == null) {
                          context.read<HomeCubit>().resetToAllDestinations();
                        } else {
                          context.read<HomeCubit>().loadDestinationsByCategory(
                            category,
                          );
                        }
                      },
                      onSearchChanged: (query) {
                        // TODO: Implement search functionality
                        // You can add search method to HomeCubit
                      },
                    ),
                  ),

                  // Top Destinations Section
                  SliverToBoxAdapter(
                    child: TopDestinationsSection(
                      destinations: state.destinations,
                    ),
                  ),

                  // Add some bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          }

          // Initial state
          return const Center(
            child: Text(
              'Welcome to Yalla R7la!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF666666),
              ),
            ),
          );
        },
      ),
    );
  }
}
