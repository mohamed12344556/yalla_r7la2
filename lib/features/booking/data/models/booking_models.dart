class BookingResponse {
  final String bookingId;
  final String status;
  final double totalAmount;
  final DateTime createdAt;

  BookingResponse({
    required this.bookingId,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      bookingId: json['bookingId'] ?? '',
      status: json['status'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
