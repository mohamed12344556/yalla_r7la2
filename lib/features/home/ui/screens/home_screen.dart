import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_loading_indicator.dart';
import '../logic/home_cubit.dart';
import '../widgets/home_header.dart';
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

  Future<void> _onRefresh() async {
    await context.read<HomeCubit>().refreshDestinations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: AppLoadingIndicator());
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
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
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: const Color(0xFF30B0C7),
                backgroundColor: Colors.white,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                            context
                                .read<HomeCubit>()
                                .loadDestinationsByCategory(category);
                          }
                        },
                        onSearchChanged: (query) {
                          if (query.isEmpty) {
                            context.read<HomeCubit>().clearFiltersAndSearch();
                          } else {
                            context.read<HomeCubit>().searchDestinations(query);
                          }
                        },
                        // onImageSearch: (imageResult) {
                        //   // Handle image search result
                        //   context
                        //       .read<HomeCubit>()
                        //       .searchDestinationsByImageResult(imageResult);
                        // },
                      ),
                    ),

                    // Search/Filter Status Bar
                    if (state.isSearching || state.isFiltered)
                      SliverToBoxAdapter(child: _buildStatusBar(state)),

                    // Top Destinations Section
                    SliverToBoxAdapter(
                      child: TopDestinationsSection(
                        destinations: state.destinations,
                      ),
                    ),

                    // Add some bottom padding
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            );
          }

          // Initial state
          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.explore_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to Yalla R7la!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover amazing destinations',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBar(HomeLoaded state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: state.isSearching ? Colors.blue[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: state.isSearching ? Colors.blue[200]! : Colors.orange[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            state.isSearching ? Icons.search : Icons.filter_alt_outlined,
            size: 20,
            color: state.isSearching ? Colors.blue[600] : Colors.orange[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              state.isSearching
                  ? 'Search results${state.searchQuery != null ? ' for "${state.searchQuery}"' : ''}'
                  : 'Filtered results',
              style: TextStyle(
                fontSize: 14,
                color:
                    state.isSearching ? Colors.blue[700] : Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<HomeCubit>().clearFiltersAndSearch();
            },
            style: TextButton.styleFrom(
              foregroundColor:
                  state.isSearching ? Colors.blue[600] : Colors.orange[600],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
