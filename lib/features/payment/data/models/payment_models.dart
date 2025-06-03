class PaymentResponse {
  final String paymentId;
  final String status;
  final double amount;
  final DateTime processedAt;

  PaymentResponse({
    required this.paymentId,
    required this.status,
    required this.amount,
    required this.processedAt,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      paymentId: json['paymentId'] ?? '',
      status: json['status'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      processedAt: DateTime.parse(
        json['processedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
