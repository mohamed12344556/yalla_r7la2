import 'dart:convert';
import 'dart:typed_data';

import '../../../home/data/model/destination_model.dart';

class BookingModel {
  final String bookingId;
  final String destinationId;
  final String destinationName;
  final String destinationLocation;
  final String imageUrl;
  final double price;
  final int passengers;
  final DateTime departureDate;
  final DateTime returnDate;
  final DateTime bookingDate;
  final BookingStatus status;
  final double totalAmount;
  final String departureTime;
  final String arrivalTime;
  final String returnDepartureTime;
  final String returnArrivalTime;

  BookingModel({
    required this.bookingId,
    required this.destinationId,
    required this.destinationName,
    required this.destinationLocation,
    required this.imageUrl,
    required this.price,
    required this.passengers,
    required this.departureDate,
    required this.returnDate,
    required this.bookingDate,
    required this.status,
    required this.totalAmount,
    this.departureTime = '08:00',
    this.arrivalTime = '14:00',
    this.returnDepartureTime = '16:00',
    this.returnArrivalTime = '22:00',
  });

  // Helper getter for displaying base64 image
  String get displayImageUrl {
    // Check if imageUrl is already a base64 data URL
    if (imageUrl.startsWith('data:image')) {
      return imageUrl;
    }

    // Check if imageUrl is a base64 string without data URL prefix
    if (_isBase64String(imageUrl)) {
      return 'data:image/jpeg;base64,$imageUrl';
    }

    // Return original URL or placeholder
    return imageUrl.isNotEmpty
        ? imageUrl
        : 'https://via.placeholder.com/400x300?text=No+Image';
  }

  // Get image as Uint8List for Image.memory()
  Uint8List? get imageBytes {
    try {
      String base64String = imageUrl;

      // Remove any data URL prefix if exists
      if (base64String.startsWith('data:')) {
        base64String = base64String.split(',').last;
      }

      // Check if it's a valid base64 string
      if (_isBase64String(base64String)) {
        return base64Decode(base64String);
      }

      return null;
    } catch (e) {
      print('Error decoding base64 image: $e');
      return null;
    }
  }

  // Helper method to check if string is base64
  bool _isBase64String(String str) {
    try {
      // Basic check for base64 pattern
      if (str.isEmpty) return false;

      // Remove padding and check if length is valid
      final withoutPadding = str.replaceAll('=', '');
      if (withoutPadding.length % 4 == 1) return false;

      // Try to decode to verify it's valid base64
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if image is base64 format
  bool get isBase64Image {
    return _isBase64String(imageUrl) || imageUrl.startsWith('data:image');
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'destinationId': destinationId,
      'destinationName': destinationName,
      'destinationLocation': destinationLocation,
      'imageUrl': imageUrl,
      'price': price,
      'passengers': passengers,
      'departureDate': departureDate.toIso8601String(),
      'returnDate': returnDate.toIso8601String(),
      'bookingDate': bookingDate.toIso8601String(),
      'status': status.name,
      'totalAmount': totalAmount,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'returnDepartureTime': returnDepartureTime,
      'returnArrivalTime': returnArrivalTime,
    };
  }

  // Create from JSON for retrieval
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'],
      destinationId: json['destinationId'],
      destinationName: json['destinationName'],
      destinationLocation: json['destinationLocation'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      passengers: json['passengers'],
      departureDate: DateTime.parse(json['departureDate']),
      returnDate: DateTime.parse(json['returnDate']),
      bookingDate: DateTime.parse(json['bookingDate']),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.confirmed,
      ),
      totalAmount: json['totalAmount'].toDouble(),
      departureTime: json['departureTime'] ?? '08:00',
      arrivalTime: json['arrivalTime'] ?? '14:00',
      returnDepartureTime: json['returnDepartureTime'] ?? '16:00',
      returnArrivalTime: json['returnArrivalTime'] ?? '22:00',
    );
  }

  // Create from DestinationModel for new booking
  factory BookingModel.fromDestination({
    required String destinationId,
    required String destinationName,
    required String destinationLocation,
    required String imageUrl,
    required double price,
    required int passengers,
    required DateTime departureDate,
    required DateTime returnDate,
  }) {
    final basePrice = price * passengers;
    final taxes = basePrice * 0.15;
    final totalAmount = basePrice + taxes;

    return BookingModel(
      bookingId: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      destinationId: destinationId,
      destinationName: destinationName,
      destinationLocation: destinationLocation,
      imageUrl: imageUrl, // This will now support base64 images
      price: price,
      passengers: passengers,
      departureDate: departureDate,
      returnDate: returnDate,
      bookingDate: DateTime.now(),
      status: BookingStatus.confirmed,
      totalAmount: totalAmount,
    );
  }

  // Enhanced factory method that accepts DestinationModel directly
  factory BookingModel.fromDestinationModel({
    required DestinationModel destination,
    required int passengers,
    required DateTime departureDate,
    required DateTime returnDate,
  }) {
    final basePrice = destination.price * passengers;
    final taxes = basePrice * 0.15;
    final totalAmount = basePrice + taxes;

    return BookingModel(
      bookingId: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      destinationId: destination.destinationId,
      destinationName: destination.name,
      destinationLocation: destination.location ?? '',
      imageUrl:
          destination
              .imageUrl, // This gets the base64 image from DestinationModel
      price: destination.price,
      passengers: passengers,
      departureDate: departureDate,
      returnDate: returnDate,
      bookingDate: DateTime.now(),
      status: BookingStatus.confirmed,
      totalAmount: totalAmount,
    );
  }

  BookingModel copyWith({
    String? bookingId,
    String? destinationId,
    String? destinationName,
    String? destinationLocation,
    String? imageUrl,
    double? price,
    int? passengers,
    DateTime? departureDate,
    DateTime? returnDate,
    DateTime? bookingDate,
    BookingStatus? status,
    double? totalAmount,
    String? departureTime,
    String? arrivalTime,
    String? returnDepartureTime,
    String? returnArrivalTime,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      destinationId: destinationId ?? this.destinationId,
      destinationName: destinationName ?? this.destinationName,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      passengers: passengers ?? this.passengers,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      bookingDate: bookingDate ?? this.bookingDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      returnDepartureTime: returnDepartureTime ?? this.returnDepartureTime,
      returnArrivalTime: returnArrivalTime ?? this.returnArrivalTime,
    );
  }

  String get formattedDepartureDate {
    return '${departureDate.day}/${departureDate.month}/${departureDate.year}';
  }

  String get formattedReturnDate {
    return '${returnDate.day}/${returnDate.month}/${returnDate.year}';
  }

  String get formattedBookingDate {
    return '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
  }

  int get tripDuration {
    return returnDate.difference(departureDate).inDays;
  }
}

enum BookingStatus { confirmed, cancelled, completed, pending }
