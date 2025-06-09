import 'dart:io';

class ChatMessage {
  final String type;
  final String message;
  final DateTime timestamp;
  final File? image;
  final List<String>? suggestions;

  ChatMessage({
    required this.type,
    required this.message,
    required this.timestamp,
    this.image,
    this.suggestions,
  });

  bool get isUser => type == "user";
  bool get isBot => type == "bot";
  bool get hasImage => image != null;
  bool get hasSuggestions => suggestions != null && suggestions!.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'message': message,
      'timestamp': timestamp,
      'image': image,
      'suggestions': suggestions,
    };
  }

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      type: map['type'] ?? '',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? DateTime.now(),
      image: map['image'],
      suggestions: map['suggestions']?.cast<String>(),
    );
  }
}
