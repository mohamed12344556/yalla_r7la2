import 'dart:io';

import 'package:yalla_r7la2/features/chat/data/models/chat_models.dart';
import 'package:yalla_r7la2/features/chat/services/tourism_chatbot.dart';

class ChatBotService {
  static const Duration _responseDelay = Duration(seconds: 2);

  /// Gets a text response based on the tourism dataset, falling back if needed.
  static Future<ChatMessage> getBotResponse(String userMessage) async {
    await Future.delayed(_responseDelay);

    // Find relevant context from the tourism data
    final context = TourismChatbot.instance.findRelevantContext(userMessage);
    // Generate the response (fallback mode always active if no model)
    final responseText = TourismChatbot.instance.generateResponse(
      userMessage,
      context: context,
    );

    return ChatMessage(
      type: 'bot',
      message: responseText,
      timestamp: DateTime.now(),
    );
  }

  /// Provides a canned image response when the user sends a photo.
  static Future<ChatMessage> getImageResponse(File image) async {
    await Future.delayed(_responseDelay);
    return ChatMessage(
      type: 'bot',
      message: '''صورة رائعة! 📸✨

يبدو أن هذا مكان سياحي مميز. هل تريد معلومات أكثر عن هذا المكان أو أماكن مشابهة؟''',
      timestamp: DateTime.now(),
      suggestions: [
        'معلومات عن المكان',
        'أماكن مشابهة',
        'كيفية الوصول',
        'أنشطة قريبة',
      ],
    );
  }

  /// Initial greeting when the chat screen loads.
  /// Initial greeting when the chat screen loads.  /// Initial greeting when the chat screen loads, delegated to tourism data.
  static ChatMessage getWelcomeMessage() {
    // Delegate welcome message and suggestions to TourismChatbot
    return TourismChatbot.getWelcomeMessage();
  }
}
