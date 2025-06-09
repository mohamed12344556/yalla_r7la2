import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/core/routes/routes.dart';
import 'package:yalla_r7la2/core/widgets/app_loading_indicator.dart';
import 'package:yalla_r7la2/features/home/ui/logic/home_cubit.dart';
import 'package:yalla_r7la2/features/home/ui/widgets/bottom_action_bar_widget.dart';
import 'package:yalla_r7la2/features/home/ui/widgets/content_section_widget.dart';
import 'package:yalla_r7la2/features/home/ui/widgets/image_carousel_widget.dart';

class DestinationDetailsScreen extends StatefulWidget {
  final String destinationId;

  const DestinationDetailsScreen({super.key, required this.destinationId});

  @override
  State<DestinationDetailsScreen> createState() =>
      _DestinationDetailsScreenState();
}

class _DestinationDetailsScreenState extends State<DestinationDetailsScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Load destination details when screen opens
    _loadDestinationDetails();
  }

  void _loadDestinationDetails() {
    context.read<HomeCubit>().getDestinationDetails(widget.destinationId);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onImageIndexChanged(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  void _showFeedbackSnackBar(BuildContext context, bool isAdded) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isAdded ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isAdded ? 'Added to favorites!' : 'Removed from favorites!',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isAdded ? Colors.green[600] : Colors.orange[600],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'View All',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, Routes.favorites);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeDetailsLoading) {
            return const Center(child: AppLoadingIndicator());
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading destination',
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
                    onPressed: _loadDestinationDetails,
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
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeDetailsLoaded) {
            final destination = state.destination;

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  ImageCarouselWidget(
                    card: destination,
                    pageController: _pageController,
                    currentImageIndex: _currentImageIndex,
                    onImageIndexChanged: _onImageIndexChanged,
                    onFeedbackShow: _showFeedbackSnackBar,
                  ),
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: ContentSectionWidget(
                          card: destination,
                          pageController: _pageController,
                          currentImageIndex: _currentImageIndex,
                          onImageIndexChanged: _onImageIndexChanged,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Initial state or no data
          return const Center(
            child: Text(
              'No destination data found',
              style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeDetailsLoaded) {
            return BottomActionBarWidget(
              card: state.destination,
              onFeedbackShow: _showFeedbackSnackBar,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
