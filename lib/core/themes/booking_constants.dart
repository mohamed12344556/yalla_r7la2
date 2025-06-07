import 'package:flutter/material.dart';

class BookingConstants {
  // Colors
  static const Color primaryBlue = Colors.blueAccent;
  static final Color lightBlue = Colors.blue[700]!;
  static final Color backgroundGrey = Colors.grey[50]!;
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black87;

  // Gradients
  static LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryBlue, lightBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get cardGradient => LinearGradient(
    colors: [primaryBlue.withOpacity(0.1), Colors.blue.withOpacity(0.05)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get imageOverlayGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Colors.black.withOpacity(0.1),
      Colors.black.withOpacity(0.4),
    ],
    stops: const [0.0, 0.7, 1.0],
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryBlue.withOpacity(0.4),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get appBarShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 12,
      offset: const Offset(0, 3),
    ),
  ];

  // Border Radius
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius smallRadius = BorderRadius.all(Radius.circular(8));
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(16),
  );
  static const BorderRadius topRadius = BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );

  // Padding & Margins
  static const EdgeInsets defaultPadding = EdgeInsets.all(24);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets smallPadding = EdgeInsets.all(8);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(
    horizontal: 24,
  );
  static const EdgeInsets verticalPadding = EdgeInsets.symmetric(vertical: 16);

  // Animation Durations
  static const Duration fadeAnimationDuration = Duration(milliseconds: 800);
  static const Duration scaleAnimationDuration = Duration(milliseconds: 600);
  static const Duration quickAnimationDuration = Duration(milliseconds: 300);

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: blackColor,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: blackColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: blackColor,
  );

  static TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey[600],
  );

  static const TextStyle priceStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryBlue,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // Sizes
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;
  static const double largeIconSize = 32.0;
  static const double buttonHeight = 56.0;
  static const double appBarHeight = 280.0;

  // Constraints
  static const int maxPassengers = 10;
  static const int minPassengers = 1;
  static const double taxRate = 0.15; // 15% tax rate

  // Days of week
  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Flight times (mock data)
  static const String defaultDepartureTime = '08:00';
  static const String defaultArrivalTime = '14:00';
  static const String defaultReturnDepartureTime = '16:00';
  static const String defaultReturnArrivalTime = '22:00';
  static const String defaultFlightDuration = '6h 00m';
}
