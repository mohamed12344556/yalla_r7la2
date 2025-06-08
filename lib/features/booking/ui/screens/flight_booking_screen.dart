import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/core/routes/routes.dart';
import 'package:yalla_r7la2/core/utils/extensions.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_destination_info.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_flight_details.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_included_features.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_passengers.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_price_breakdown.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_travel_dates.dart';

import '../../../home/data/model/destination_model.dart';
import '../logic/bookings_cubit.dart';

class FlightBookingScreen extends StatefulWidget {
  final DestinationModel destination;

  const FlightBookingScreen({super.key, required this.destination});

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
  DateTime returnDate = DateTime.now().add(const Duration(days: 10));
  int passengers = 1;
  bool _isBookingInProgress = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkExistingBooking();
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
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _checkExistingBooking() {
    final bookingsCubit = context.read<BookingsCubit>();
    final isAlreadyBooked = bookingsCubit.isDestinationBooked(
      widget.destination.destinationId,
    );

    if (isAlreadyBooked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAlreadyBookedDialog();
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingsCubit, BookingsState>(
      listener: _handleBookingStateChanges,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: CustomScrollView(
          slivers: [
            // App Bar with destination image
            _buildSliverAppBar(),

            // Booking Content
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Booking Status Banner
                          _buildBookingStatusBanner(),

                          // Destination Info
                          BookingDestinationInfo(
                            destination: widget.destination,
                          ),
                          const SizedBox(height: 24),

                          // Travel Dates Section
                          BookingTravelDates(
                            selectedDate: selectedDate,
                            returnDate: returnDate,
                            onDateSelected: _onDateSelected,
                          ),
                          const SizedBox(height: 24),

                          // Passengers Section
                          BookingPassengers(
                            passengers: passengers,
                            onPassengersChanged:
                                (value) => setState(() => passengers = value),
                          ),
                          const SizedBox(height: 24),

                          // Flight Details Section
                          BookingFlightDetails(destination: widget.destination),
                          const SizedBox(height: 24),

                          // Price Breakdown
                          BookingPriceBreakdown(
                            basePrice: widget.destination.price,
                            passengers: passengers,
                          ),
                          const SizedBox(height: 24),

                          // Features Included
                          if (widget.destination.features != null)
                            BookingIncludedFeatures(
                              features: widget.destination.features!,
                            ),

                          // Booking Conflict Warning
                          _buildBookingConflictWarning(),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Bottom booking button
        bottomNavigationBar: _buildBottomBookingBar(),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      scrolledUnderElevation: 0,
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.bookmark_border,
              color: Colors.black,
              size: 20,
            ),
            onPressed: _toggleBookmark,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Book ${widget.destination.name}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        background: Stack(
          children: [
            Hero(
              tag: 'destination_${widget.destination.destinationId}_booking',
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(widget.destination.imageBytes!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingStatusBanner() {
    final bookingsCubit = context.read<BookingsCubit>();
    final isAlreadyBooked = bookingsCubit.isDestinationBooked(
      widget.destination.destinationId,
    );

    if (!isAlreadyBooked) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Already Booked',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'You have already booked this destination',
                  style: TextStyle(color: Colors.orange.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingConflictWarning() {
    final bookingsCubit = context.read<BookingsCubit>();
    final hasConflict = bookingsCubit.hasBookingConflict(
      destinationId: widget.destination.destinationId,
      departureDate: selectedDate,
      returnDate: returnDate,
    );

    if (!hasConflict) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_outlined, color: Colors.red.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date Conflict',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Your selected dates conflict with existing booking',
                  style: TextStyle(color: Colors.red.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBookingBar() {
    final bookingsCubit = context.read<BookingsCubit>();
    final isAlreadyBooked = bookingsCubit.isDestinationBooked(
      widget.destination.destinationId,
    );
    final hasConflict = bookingsCubit.hasBookingConflict(
      destinationId: widget.destination.destinationId,
      departureDate: selectedDate,
      returnDate: returnDate,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '\$${(widget.destination.price * passengers * 1.15).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$passengers passenger${passengers > 1 ? 's' : ''}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Book Now Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: BlocBuilder<BookingsCubit, BookingsState>(
                builder: (context, state) {
                  final isLoading =
                      state is BookingsLoading || _isBookingInProgress;

                  return AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: isLoading ? _pulseAnimation.value : 1.0,
                        child: ElevatedButton(
                          onPressed:
                              (isAlreadyBooked || hasConflict || isLoading)
                                  ? null
                                  : _handleBookNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isAlreadyBooked || hasConflict
                                    ? Colors.grey.shade400
                                    : const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                            elevation: isLoading ? 8 : 4,
                            shadowColor: const Color(
                              0xFF2196F3,
                            ).withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child:
                              isLoading
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Booking...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                  : Text(
                                    isAlreadyBooked
                                        ? 'Already Booked'
                                        : hasConflict
                                        ? 'Date Conflict'
                                        : 'Book Now',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBookingStateChanges(BuildContext context, BookingsState state) {
    if (state is BookingsLoading) {
      setState(() => _isBookingInProgress = true);
    } else {
      setState(() => _isBookingInProgress = false);
    }

    if (state is BookingAdded) {
      _showBookingSuccessDialog(state.remainingSlots);
    } else if (state is BookingsError) {
      _showErrorDialog(state.message);
    }
  }

  void _handleBookNow() async {
    // Show confirmation dialog first
    final confirmed = await _showBookingConfirmationDialog();
    if (!confirmed) return;

    // Add booking through cubit
    context.read<BookingsCubit>().addBooking(
      destination: widget.destination,
      passengers: passengers,
      departureDate: selectedDate,
      returnDate: returnDate,
    );
  }

  Future<bool> _showBookingConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text('Confirm Booking'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Destination: ${widget.destination.name}'),
                    Text('Passengers: $passengers'),
                    Text(
                      'Departure: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                    Text(
                      'Return: ${returnDate.day}/${returnDate.month}/${returnDate.year}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: \$${(widget.destination.price * passengers * 1.15).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _showBookingSuccessDialog(int remainingSlots) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.green.shade600,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Booking Successful!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your booking has been confirmed for ${widget.destination.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                if (remainingSlots > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '$remainingSlots slots remaining',
                    style: TextStyle(
                      color: Colors.orange.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pushNamed(Routes.myBookings);
                },
                child: const Text('View Bookings'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600),
                const SizedBox(width: 8),
                const Text('Booking Failed'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleBookNow();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
    );
  }

  void _showAlreadyBookedDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade600),
                const SizedBox(width: 8),
                Text(
                  'Already Booked',
                  style: TextStyle(
                    foreground:
                        Paint()
                          ..shader = LinearGradient(
                            colors: [Colors.red.shade700, Colors.blue.shade300],
                          ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 70.0, 70.0),
                          ),
                  ),
                ),
              ],
            ),
            content: Text(
              'You have already booked ${widget.destination.name}. Check your bookings to view details.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: TextStyle(
                    foreground:
                        Paint()
                          ..shader = LinearGradient(
                            colors: [
                              Colors.blue.shade700,
                              Colors.blue.shade300,
                            ],
                          ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                          ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pushNamed(Routes.myBookings);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                ),
                child: const Text('View Bookings'),
              ),
            ],
          ),
    );
  }

  void _onDateSelected(DateTime selectedDate, DateTime returnDate) {
    setState(() {
      this.selectedDate = selectedDate;
      this.returnDate = returnDate;
    });
  }

  void _toggleBookmark() {
    // Implementation for bookmark functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bookmark feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
