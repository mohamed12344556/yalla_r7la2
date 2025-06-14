import 'dart:io';

import 'package:yalla_r7la2/features/chat/data/models/chat_models.dart';
import 'package:yalla_r7la2/features/chat/services/enhanced_chatbot.dart';
import 'package:yalla_r7la2/features/chat/services/tourism_chatbot.dart';

class ChatBotService {
  static const Duration _responseDelay = Duration(seconds: 2);

  /// Initialize the enhanced chatbot with Gemini API key
  /// Call this in your app initialization (main.dart or app startup)
  static void initialize({String? geminiApiKey}) {
    if (geminiApiKey != null && geminiApiKey.isNotEmpty) {
      EnhancedChatBotService.initializeGemini(geminiApiKey);
      print('ChatBotService initialized with Gemini AI');

      // إجراء اختبار أولي للتأكد من عمل النظام
      _performInitialTest();
    } else {
      print('ChatBotService initialized with local AI only');
    }
  }

  /// اختبار أولي للنظام
  static void _performInitialTest() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final diagnostics = await EnhancedChatBotService.performDiagnostics();
      print('🔍 System diagnostics completed');
      print(
        '   • Gemini Status: ${diagnostics['isInitialized'] ? "✅ Active" : "❌ Inactive"}',
      );

      if (diagnostics['connectionTest']['success'] == true) {
        print('   • Connection Test: ✅ Passed');
      } else {
        print(
          '   • Connection Test: ❌ Failed - ${diagnostics['connectionTest']['error']}',
        );
      }
    } catch (e) {
      print('⚠️ Initial test failed: $e');
    }
  }

  /// Gets a text response using enhanced AI or fallback to local tourism data
  static Future<ChatMessage> getBotResponse(String userMessage) async {
    // Use enhanced service with retry mechanism if available
    if (EnhancedChatBotService.isGeminiAvailable) {
      try {
        return await EnhancedChatBotService.getBotResponseWithRetry(
          userMessage,
        );
      } catch (e) {
        print(
          '❌ Enhanced service failed completely, falling back to local: $e',
        );
        return _getLocalResponse(userMessage);
      }
    } else {
      // Original implementation as fallback
      return _getLocalResponse(userMessage);
    }
  }

  /// Local fallback response
  static Future<ChatMessage> _getLocalResponse(String userMessage) async {
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
      suggestions: _generateLocalSuggestions(userMessage),
    );
  }

  /// Generate local suggestions based on user message
  static List<String> _generateLocalSuggestions(String userMessage) {
    final text = userMessage.toLowerCase();

    if (text.contains('أهرام') || text.contains('pyramid')) {
      return ['عرض الصوت والضوء', 'أبو الهول', 'متحف الآثار', 'رحلة جيزة'];
    } else if (text.contains('أقصر') || text.contains('luxor')) {
      return ['معبد الكرنك', 'وادي الملوك', 'معبد الأقصر', 'رحلة نيلية'];
    } else if (text.contains('أسوان') || text.contains('aswan')) {
      return ['السد العالي', 'معبد فيلة', 'الجزر النيلية', 'القرية النوبية'];
    } else if (text.contains('شرم') || text.contains('sharm')) {
      return ['رحلة غوص', 'رأس محمد', 'نعمة باي', 'سفاري صحراوي'];
    }

    return ['الأهرامات', 'أقصر وأسوان', 'البحر الأحمر', 'الأكلات المصرية'];
  }

  /// Enhanced image response using Gemini Vision or fallback
  static Future<ChatMessage> getImageResponse(File image) async {
    if (EnhancedChatBotService.isGeminiAvailable) {
      try {
        return await EnhancedChatBotService.getImageResponse(image);
      } catch (e) {
        print('❌ Image analysis failed, using fallback: $e');
        return _getDefaultImageResponse();
      }
    } else {
      return _getDefaultImageResponse();
    }
  }

  /// Default image response
  static Future<ChatMessage> _getDefaultImageResponse() async {
    await Future.delayed(_responseDelay);
    return ChatMessage(
      type: 'bot',
      message: '''صورة رائعة! 📸✨

يبدو أن هذا مكان سياحي مميز. هل تريد معلومات أكثر عن هذا المكان أو أماكن مشابهة؟

💡 يمكنني مساعدتك في:
• تحديد الأماكن بالوصف  
• اقتراح أنشطة مناسبة
• معلومات مفصلة عن المعالم
• تخطيط برنامج سياحي

🔍 صف لي المكان أو أخبرني عن اهتماماتك!''',
      timestamp: DateTime.now(),
      suggestions: [
        'أصف المكان',
        'أماكن أثرية',
        'رحلات بحرية',
        'سياحة صحراوية',
      ],
    );
  }

  /// Initial greeting when the chat screen loads.
  static ChatMessage getWelcomeMessage() {
    // Get base welcome message from TourismChatbot
    final baseMessage = TourismChatbot.getWelcomeMessage();

    // Enhanced status information
    final aiStatus = EnhancedChatBotService.statusMessage;
    final systemInfo = EnhancedChatBotService.getSystemStatus();

    final enhancedMessage = '''${baseMessage.message}
    
${systemInfo['gemini']['initialized'] ? '🚀 الذكاء الاصطناعي المتقدم متاح' : '💬 النظام الأساسي نشط'}''';

    return ChatMessage(
      type: baseMessage.type,
      message: enhancedMessage,
      timestamp: baseMessage.timestamp,
      suggestions: baseMessage.suggestions,
    );
  }

  /// Get current AI service status
  static String get aiServiceStatus => EnhancedChatBotService.statusMessage;

  /// Check if enhanced features are available
  static bool get hasEnhancedFeatures =>
      EnhancedChatBotService.isGeminiAvailable;

  /// Get detailed system status (for debugging)
  static Map<String, dynamic> getSystemStatus() =>
      EnhancedChatBotService.getSystemStatus();

  /// Perform system diagnostics
  static Future<Map<String, dynamic>> performDiagnostics() =>
      EnhancedChatBotService.performDiagnostics();

  /// Reset and reinitialize the AI service
  static Future<bool> reinitializeAI(String apiKey) =>
      EnhancedChatBotService.reinitialize(apiKey);
}
