class ChatResponse {
  final String response;
  final String timestamp;

  ChatResponse({required this.response, required this.timestamp});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
