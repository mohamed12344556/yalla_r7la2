import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/core/widgets/app_loading_indicator.dart';

import '../../data/model/destination_model.dart';
import '../logic/home_cubit.dart';
import 'destination_card.dart';

class TopDestinationsSection extends StatefulWidget {
  final List<DestinationModel> destinations;

  const TopDestinationsSection({super.key, required this.destinations});

  @override
  State<TopDestinationsSection> createState() => _TopDestinationsSectionState();
}

class _TopDestinationsSectionState extends State<TopDestinationsSection> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from bottom
      final cubit = context.read<HomeCubit>();
      final state = cubit.state;

      if (state is HomeLoaded && state.canLoadMore && !cubit.isLoadingMore) {
        cubit.loadMoreDestinations();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(state),
              const SizedBox(height: 16),
              if (widget.destinations.isEmpty)
                _buildEmptyState()
              else
                _buildDestinationsList(state),

              // Pagination controls
              if (state is HomeLoaded) ...[
                const SizedBox(height: 16),
                _buildPaginationInfo(state),
                const SizedBox(height: 8),
                _buildPaginationControls(state),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(HomeState state) {
    return Row(
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
        if (state is HomeLoaded) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${widget.destinations.length} trips",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (state.isSearching)
                Text(
                  "Search results",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDestinationsList(HomeState state) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height *
          0.6, // Increased height for pagination
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount:
            widget.destinations.length +
            (state is HomeLoaded && state.hasMorePages && !state.isSearching
                ? 1
                : 0),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          // Show destination cards
          if (index < widget.destinations.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DestinationCard(cardData: widget.destinations[index]),
            );
          }

          // Show loading indicator at the end
          if (state is HomeLoaded && state.hasMorePages && !state.isSearching) {
            return _buildLoadMoreIndicator();
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: Column(
          children: [
            AppLoadingIndicator(),
            SizedBox(height: 8),
            Text(
              'Loading more destinations...',
              style: TextStyle(color: Color(0xFF666666), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationInfo(HomeLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            state.paginationInfo,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (state.hasMorePages)
            Text(
              'Page ${state.currentPage} of ${state.totalPages}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[600],
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(HomeLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Load More Button (Alternative to infinite scroll)
        if (state.hasMorePages && !state.isSearching && !state.isFiltered)
          ElevatedButton.icon(
            onPressed:
                context.read<HomeCubit>().isLoadingMore
                    ? null
                    : () {
                      context.read<HomeCubit>().loadMoreDestinations();
                    },
            icon:
                context.read<HomeCubit>().isLoadingMore
                    ? AppLoadingIndicator()
                    : const Icon(Icons.add, size: 18),
            label: Text(
              context.read<HomeCubit>().isLoadingMore
                  ? 'Loading...'
                  : 'Load More',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF30B0C7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

        const SizedBox(width: 16),

        // Refresh Button
        OutlinedButton.icon(
          onPressed: () {
            context.read<HomeCubit>().refreshDestinations();
          },
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Refresh'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF30B0C7),
            side: const BorderSide(color: Color(0xFF30B0C7)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
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
            'Try selecting a different category or refresh',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
