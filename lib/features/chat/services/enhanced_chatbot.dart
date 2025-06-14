import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:yalla_r7la2/features/chat/data/models/chat_models.dart';
import 'package:yalla_r7la2/features/chat/services/tourism_chatbot.dart';

class EnhancedChatBotService {
  static const Duration _responseDelay = Duration(milliseconds: 500);
  static Gemini? _gemini;
  static bool _isGeminiInitialized = false;

  /// Initialize Gemini with your API key
  static void initializeGemini(String apiKey) {
    try {
      Gemini.init(
        apiKey: apiKey,
        enableDebugging: true, // تفعيل debugging لتتبع المشاكل
      );
      _gemini = Gemini.instance;
      _isGeminiInitialized = true;
      print('✅ Gemini initialized successfully');
      _testConnection(); // اختبار الاتصال
    } catch (e) {
      print('❌ Failed to initialize Gemini: $e');
      _isGeminiInitialized = false;
    }
  }

  /// اختبار شامل لحالة Gemini
  static Future<Map<String, dynamic>> performDiagnostics() async {
    final diagnostics = <String, dynamic>{
      'isInitialized': _isGeminiInitialized,
      'hasInstance': _gemini != null,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (_isGeminiInitialized && _gemini != null) {
      try {
        final testResponse = await _gemini!.text('مرحبا');
        diagnostics['connectionTest'] = {
          'success': true,
          'response': testResponse?.output ?? 'لا يوجد رد',
          'responseLength': testResponse?.output?.length ?? 0,
        };
        print('✅ Gemini diagnostics: Connection successful');
      } catch (e) {
        diagnostics['connectionTest'] = {
          'success': false,
          'error': e.toString(),
        };
        print('❌ Gemini diagnostics: Connection failed - $e');
        _isGeminiInitialized = false;
      }
    } else {
      diagnostics['connectionTest'] = {
        'success': false,
        'error': 'Gemini not initialized',
      };
    }

    return diagnostics;
  }

  /// إعادة تهيئة Gemini مع اختبار
  static Future<bool> reinitialize(String apiKey) async {
    try {
      print('🔄 Reinitializing Gemini...');

      // إعادة تعيين الحالة
      _isGeminiInitialized = false;
      _gemini = null;

      // تهيئة جديدة
      Gemini.init(apiKey: apiKey, enableDebugging: true);
      _gemini = Gemini.instance;

      // اختبار الاتصال
      final testResponse = await _gemini!.text('اختبار');
      if (testResponse?.output != null) {
        _isGeminiInitialized = true;
        print('✅ Gemini reinitialized successfully');
        return true;
      } else {
        throw Exception('Empty response from Gemini');
      }
    } catch (e) {
      print('❌ Failed to reinitialize Gemini: $e');
      _isGeminiInitialized = false;
      _gemini = null;
      return false;
    }
  }

  /// الحصول على معلومات مفصلة عن حالة النظام
  static Map<String, dynamic> getSystemStatus() {
    return {
      'gemini': {
        'initialized': _isGeminiInitialized,
        'hasInstance': _gemini != null,
        'status': statusMessage,
      },
      'fallback': {'available': true, 'type': 'TourismChatbot'},
      'services': {
        'textGeneration': _isGeminiInitialized ? 'Gemini AI' : 'Local Fallback',
        'imageAnalysis':
            _isGeminiInitialized ? 'Gemini Vision' : 'Basic Response',
      },
    };
  }

  /// معالجة محسنة للأخطاء
  static Future<ChatMessage> getBotResponseWithRetry(
    String userMessage, {
    int maxRetries = 2,
  }) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        return await getBotResponse(userMessage);
      } catch (e) {
        print('❌ Attempt ${attempt + 1} failed: $e');

        if (attempt == maxRetries - 1) {
          // آخر محاولة فاشلة، استخدم الـ fallback
          print('🔄 All attempts failed, using fallback');
          return ChatMessage(
            type: 'bot',
            message: '''عذراً، واجهت مشكلة تقنية مؤقتة 🔧

لا تقلق! يمكنني مساعدتك بالطرق التقليدية:

🏺 معلومات عن الآثار المصرية
🏖️ تخطيط الرحلات الشاطئية  
🏜️ ترتيب رحلات السفاري
🍽️ التعريف بالأكلات المصرية

💡 جرب إعادة صياغة سؤالك أو اختر من الاقتراحات أدناه''',
            timestamp: DateTime.now(),
            suggestions: [
              'الأهرامات والآثار',
              'شرم الشيخ والغردقة',
              'رحلة أسوان وأقصر',
              'الأكلات المصرية',
            ],
          );
        }

        // انتظار قصير قبل المحاولة التالية
        await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
      }
    }

    throw Exception('This should never be reached');
  }

  /// اختبار الاتصال مع Gemini
  static Future<void> _testConnection() async {
    try {
      final response = await _gemini!.text("مرحبا");
      print('✅ Gemini connection test successful: ${response?.output}');
    } catch (e) {
      print('❌ Gemini connection test failed: $e');
      _isGeminiInitialized = false;
    }
  }

  /// Enhanced bot response using Gemini AI with tourism context
  static Future<ChatMessage> getBotResponse(String userMessage) async {
    print('🔄 Processing message: $userMessage');

    await Future.delayed(_responseDelay);

    // Always get context from tourism data
    final context = TourismChatbot.instance.findRelevantContext(userMessage);

    String responseText;
    List<String>? suggestions;

    if (_isGeminiInitialized && _gemini != null) {
      try {
        print('🤖 Using Gemini AI for response');
        // Generate response using Gemini AI
        final result = await _generateGeminiResponse(userMessage, context);
        responseText =
            result['response'] ?? _getFallbackResponse(userMessage, context);
        suggestions = result['suggestions'];

        print('✅ Gemini response generated successfully');
      } catch (e) {
        print('❌ Gemini error: $e');
        // Fallback to local tourism chatbot
        responseText = TourismChatbot.instance.generateResponse(
          userMessage,
          context: context,
        );
        suggestions = _generateSuggestions(userMessage);
        print('🔄 Using fallback response');
      }
    } else {
      print('📱 Using local tourism chatbot');
      // Use local tourism chatbot
      responseText = TourismChatbot.instance.generateResponse(
        userMessage,
        context: context,
      );
      suggestions = _generateSuggestions(userMessage);
    }

    return ChatMessage(
      type: 'bot',
      message: responseText,
      timestamp: DateTime.now(),
      suggestions: suggestions,
    );
  }

  /// Generate response using Gemini AI with tourism context
  static Future<Map<String, dynamic>> _generateGeminiResponse(
    String userMessage,
    String? context,
  ) async {
    try {
      // Create a comprehensive prompt for Egyptian tourism
      final prompt = _buildTourismPrompt(userMessage, context);

      print('📝 Sending prompt to Gemini');

      final response = await _gemini!.text(prompt);
      final responseText = response?.output ?? '';

      if (responseText.isEmpty) {
        throw Exception('Empty response from Gemini');
      }

      print(
        '📦 Received response from Gemini: ${responseText.substring(0, responseText.length > 100 ? 100 : responseText.length)}...',
      );

      // Parse response to extract suggestions if formatted properly
      final parsed = _parseGeminiResponse(responseText);

      return {
        'response': parsed['response'],
        'suggestions': parsed['suggestions'],
      };
    } catch (e) {
      print('❌ Gemini API error: $e');
      rethrow;
    }
  }

  /// Build comprehensive tourism prompt for Gemini
  static String _buildTourismPrompt(String userMessage, String? context) {
    final basePrompt = '''
أنت "مساعد السفر الذكي" 🤖 - خبير سياحي مصري متخصص في السياحة المصرية. 

شخصيتك:
- ودود ومرحب بالسياح من جميع أنحاء العالم
- خبير في السياحة المصرية بجميع أنواعها
- تتحدث باللغة العربية بطريقة سهلة ومفهومة
- تستخدم الإيموجي لجعل المحادثة أكثر حيوية

مهامك الرئيسية:
🏺 تقديم معلومات دقيقة عن الآثار المصرية
🏖️ المساعدة في التخطيط للرحلات الشاطئية
🏜️ ترتيب الرحلات الصحراوية والسفاري
🚢 تنظيم الرحلات النيلية
🍽️ التعريف بالأكلات المصرية الأصيلة
🏨 اقتراح أفضل أماكن الإقامة
🚗 شرح وسائل المواصلات
💰 تقدير التكاليف والميزانيات
📅 اقتراح برامج سياحية مناسبة

قواعد الرد:
- اجعل ردك مفيداً وعملياً (200-300 كلمة كحد أقصى)
- استخدم إيموجي مناسب ولكن لا تفرط فيه
- قدم 3-4 اقتراحات عملية في نهاية كل رد
- إذا سأل عن مكان خارج مصر، وجهه بلطف لأماكن مصرية مشابهة
- تأكد من دقة المعلومات وحداثتها

${context != null ? '\nمعلومات إضافية ذات صلة:\n$context\n' : ''}

سؤال الزائر: "$userMessage"

ملاحظة: في نهاية ردك، أضف سطر منفصل يبدأ بـ "الاقتراحات:" متبوعاً بـ 4 اقتراحات مفصولة بـ " | "

مثال للتنسيق:
الاقتراحات: معلومات أكثر | كيفية الوصول | التكلفة المتوقعة | أماكن قريبة

الرد:
''';

    return basePrompt;
  }

  /// Parse Gemini response to extract main response and suggestions
  static Map<String, dynamic> _parseGeminiResponse(String response) {
    List<String> suggestions = [];
    String mainResponse = response;

    // البحث عن الاقتراحات في التنسيق المحدد
    if (response.contains('الاقتراحات:')) {
      final parts = response.split('الاقتراحات:');
      if (parts.length > 1) {
        mainResponse = parts[0].trim();
        final suggestionsPart = parts[1].trim();
        suggestions =
            suggestionsPart
                .split('|')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .take(4)
                .toList();
      }
    }

    // Try alternative formats
    if (suggestions.isEmpty) {
      if (response.contains('🔍') ||
          response.contains('💡') ||
          response.contains('اقتراحات')) {
        final lines = response.split('\n');
        final suggestionLines = <String>[];
        final responseLines = <String>[];

        bool inSuggestionSection = false;

        for (String line in lines) {
          if (line.contains('🔍') ||
              line.contains('💡') ||
              line.contains('اقتراحات')) {
            inSuggestionSection = true;
            continue;
          }

          if (inSuggestionSection &&
              (line.trim().startsWith('•') || line.trim().startsWith('-'))) {
            suggestionLines.add(
              line.replaceAll(RegExp(r'^[•\-]\s*'), '').trim(),
            );
          } else if (!inSuggestionSection) {
            responseLines.add(line);
          }
        }

        if (suggestionLines.isNotEmpty) {
          suggestions = suggestionLines.take(4).toList();
          mainResponse = responseLines.join('\n').trim();
        }
      }
    }

    // Fallback suggestions if none were extracted
    if (suggestions.isEmpty) {
      suggestions = _generateSuggestions(mainResponse);
    }

    return {'response': mainResponse, 'suggestions': suggestions};
  }

  /// Generate contextual suggestions based on the response
  static List<String> _generateSuggestions(String messageOrResponse) {
    final text = messageOrResponse.toLowerCase();

    // خريطة الكلمات المفتاحية والاقتراحات المرتبطة بها
    final Map<String, List<String>> keywordSuggestions = {
      'أهرام|pyramid|giza': [
        'دخول الهرم الأكبر',
        'عرض الصوت والضوء',
        'أبو الهول',
        'متحف الآثار',
      ],
      'أقصر|luxor|الأقصر': [
        'معبد الكرنك',
        'وادي الملوك',
        'معبد الأقصر',
        'رحلة نيلية',
      ],
      'أسوان|aswan': [
        'السد العالي',
        'معبد فيلة',
        'الجزر النيلية',
        'القرية النوبية',
      ],
      'شرم|sharm|شيخ': ['رحلة غوص', 'رأس محمد', 'نعمة باي', 'سفاري صحراوي'],
      'الغردقة|hurghada': ['الجونة', 'رحلة دلافين', 'الغوص', 'رحلة صحراوية'],
      'إسكندرية|alexandria': [
        'مكتبة الإسكندرية',
        'قلعة قايتباي',
        'كورنيش الإسكندرية',
        'عمود السواري',
      ],
      'طعام|أكل|مطعم|food': [
        'الكشري المصري',
        'المولوخية',
        'الفول والطعمية',
        'الحلويات الشرقية',
      ],
      'فندق|إقامة|hotel': [
        'فنادق 5 نجوم',
        'فنادق اقتصادية',
        'منتجعات البحر الأحمر',
        'فنادق تاريخية',
      ],
      'مواصلات|transport|طيران': [
        'رحلات داخلية',
        'القطارات',
        'الأتوبيس السياحي',
        'تأجير سيارة',
      ],
    };

    // البحث في الكلمات المفتاحية
    for (final entry in keywordSuggestions.entries) {
      final keywords = entry.key.split('|');
      if (keywords.any((keyword) => text.contains(keyword))) {
        return entry.value;
      }
    }

    // Default suggestions
    return ['الأهرامات', 'رحلة أقصر', 'البحر الأحمر', 'الأكلات المصرية'];
  }

  /// Fallback response when Gemini fails
  static String _getFallbackResponse(String userMessage, String? context) {
    return TourismChatbot.instance.generateResponse(
      userMessage,
      context: context,
    );
  }

  /// Enhanced image response using Gemini Vision (if available)
  static Future<ChatMessage> getImageResponse(File image) async {
    print('📸 Processing image with AI');

    await Future.delayed(_responseDelay);

    if (_isGeminiInitialized && _gemini != null) {
      try {
        // Read image as bytes
        final Uint8List imageBytes = await image.readAsBytes();
        print('📷 Image loaded, size: ${imageBytes.length} bytes');

        // Use Gemini Vision to analyze the image
        final response = await _gemini!.textAndImage(
          text: '''
أنت خبير سياحي مصري، حلل هذه الصورة بدقة وأجب على التالي:

1️⃣ هل هذا مكان سياحي مصري؟ إذا نعم، ما اسمه بالتحديد؟
2️⃣ صف المعالم والتفاصيل المهمة الظاهرة في الصورة
3️⃣ معلومات مفيدة عن هذا المكان (التاريخ، الأهمية، أفضل وقت للزيارة)
4️⃣ نصائح عملية للزائرين (التكلفة، المدة المناسبة، ما يجب أخذه)

المتطلبات:
✅ الرد باللغة العربية فقط
✅ استخدم الإيموجي بشكل مناسب
✅ كن دقيقاً ومفيداً
✅ لا تتجاوز 250 كلمة
✅ إذا لم تكن الصورة لمكان مصري، اقترح أماكن مصرية مشابهة

في النهاية أضف:
الاقتراحات: معلومات إضافية | كيفية الوصول | الأنشطة المتاحة | أماكن قريبة
          ''',
          images: [imageBytes],
        );

        final responseText =
            response?.output ?? _getDefaultImageResponse().message;

        print('✅ Image analysis completed');

        // Parse the response to extract suggestions
        final parsed = _parseGeminiResponse(responseText);

        return ChatMessage(
          type: 'bot',
          message: parsed['response'],
          timestamp: DateTime.now(),
          suggestions:
              parsed['suggestions'] ??
              [
                'معلومات عن المكان',
                'أماكن مشابهة',
                'كيفية الوصول',
                'أنشطة قريبة',
              ],
        );
      } catch (e) {
        print('❌ Gemini Vision error: $e');
        // Fallback to default image response
        return _getDefaultImageResponse();
      }
    } else {
      print('📱 Using default image response');
      return _getDefaultImageResponse();
    }
  }

  /// Default image response
  static ChatMessage _getDefaultImageResponse() {
    return ChatMessage(
      type: 'bot',
      message: '''صورة رائعة! 📸✨

يبدو أن هذا مكان سياحي مميز. للأسف لا أستطيع تحليل الصورة بدقة حالياً، لكن يمكنني مساعدتك بطرق أخرى!

💡 يمكنني مساعدتك في:
• تحديد الأماكن السياحية المصرية بالوصف
• اقتراح أنشطة مناسبة لاهتماماتك
• معلومات مفصلة عن أي مكان تريد زيارته
• تخطيط برنامج سياحي متكامل

🔍 جرب أن تصف لي المكان أو تخبرني عن اهتماماتك السياحية!''',
      timestamp: DateTime.now(),
      suggestions: [
        'أصف المكان',
        'أماكن أثرية',
        'رحلات بحرية',
        'سياحة صحراوية',
      ],
    );
  }

  /// Check if Gemini is properly initialized and working
  static bool get isGeminiAvailable => _isGeminiInitialized;

  /// Get detailed initialization status
  static String get statusMessage {
    if (_isGeminiInitialized) {
      return 'Gemini AI مُفعل وجاهز 🤖✅';
    } else {
      return 'النظام الأساسي مُفعل (بدون AI متقدم) 💬';
    }
  }

  /// Get connection status for debugging
  static String get connectionStatus {
    return _isGeminiInitialized ? 'متصل' : 'غير متصل';
  }

  /// Reset connection (for troubleshooting)
  static void resetConnection() {
    _isGeminiInitialized = false;
    _gemini = null;
    print('🔄 Gemini connection reset');
  }
}
