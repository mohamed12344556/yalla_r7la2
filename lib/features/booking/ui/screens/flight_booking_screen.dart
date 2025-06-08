import 'package:flutter/material.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_bottom_bar.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_destination_info.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_flight_details.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_included_features.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_passengers.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_price_breakdown.dart';
import 'package:yalla_r7la2/features/booking/ui/widgets/booking/booking_travel_dates.dart';

import '../../../home/data/model/destination_model.dart';
import '../../../payment/ui/screens/payment.dart';

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
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
  DateTime returnDate = DateTime.now().add(const Duration(days: 10));
  int passengers = 1;

  @override
  void initState() {
    super.initState();
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

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        // Destination Info
                        BookingDestinationInfo(destination: widget.destination),
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
      bottomNavigationBar: BookingBottomBar(
        totalPrice: widget.destination.price * passengers,
        passengers: passengers,
        onProceedToPayment: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaymentPage()),
          );
        },
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

  void _onDateSelected(DateTime selectedDate, DateTime returnDate) {
    setState(() {
      this.selectedDate = selectedDate;
      this.returnDate = returnDate;
    });
  }
}
