import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:yalla_r7la2/features/chat/data/models/chat_models.dart';
import 'package:yalla_r7la2/features/chat/data/models/tourism_data.dart';

class TourismChatbot {
  static final TourismChatbot _instance = TourismChatbot._internal();
  static TourismChatbot get instance => _instance;
  List<TourismData> _tourismData = [];
  bool modelAvailable = false;
  bool fallbackMode = true;

  // إضافة متغير لتتبع الأسئلة السابقة
  final List<String> _previousQuestions = [];
  final Random _random = Random();

  // قاموس أكثر تفصيلاً للمعالم المصرية مع مرادفات
  final Map<String, Map<String, dynamic>> _egyptianLandmarks = {
    'pyramid': {
      'keywords': [
        'pyramid',
        'pyramids',
        'giza',
        'khufu',
        'cheops',
        'هرم',
        'أهرام',
        'جيزة',
        'خوفو',
      ],
      'responses': [
        'الأهرامات في الجيزة هي من أعظم عجائب العالم القديم! 🏺✨ تم بناؤها منذ أكثر من 4500 سنة وتعتبر مقابر للفراعنة العظام.',
        'أهرامات الجيزة تضم ثلاثة أهرامات رئيسية: خوفو (الأكبر)، خفرع، ومنقرع. هرم خوفو كان أطول مبنى في العالم لأكثر من 3800 سنة! 🏗️',
        'زيارة الأهرامات تجربة لا تُنسى! 🌟 يمكنك دخول الهرم الأكبر (رسوم إضافية) ومشاهدة التحف في المتحف المجاور.',
      ],
      'suggestions': [
        'دخول الهرم الأكبر',
        'رحلة صوت وضوء',
        'متحف مركب خوفو',
        'التصوير مع الأهرامات',
      ],
    },
    'sphinx': {
      'keywords': ['sphinx', 'أبو الهول', 'تمثال', 'statue'],
      'responses': [
        'أبو الهول الأسطوري! 🦁 تمثال عملاق برأس إنسان وجسم أسد، يحرس الأهرامات منذ آلاف السنين.',
        'يبلغ طول أبو الهول 73 متر وارتفاعه 20 متر. يُعتقد أنه يمثل الملك خفرع وتم نحته من قطعة واحدة من الحجر الجيري! 🗿',
        'أبو الهول من أكبر التماثيل المنحوتة في العالم. لا تفوت عرض الصوت والضوء المسائي الرائع! 🌙',
      ],
      'suggestions': [
        'عرض الصوت والضوء',
        'تاريخ أبو الهول',
        'الألغاز والأساطير',
        'أفضل زوايا التصوير',
      ],
    },
  };

  // إضافة أنماط مختلفة للردود
  final Map<String, List<String>> _responsePatterns = {
    'greeting': [
      'أهلاً وسهلاً! 👋 كيف يمكنني مساعدتك في رحلتك للتعرف على مصر الجميلة؟',
      'مرحباً بك! 🌟 سعيد جداً بلقائك، ما الذي تود معرفته عن السياحة في مصر؟',
      'أهلاً بك في عالم السياحة المصرية! ✈️ كيف يمكنني أن أجعل رحلتك لا تُنسى؟',
    ],
    'thanks': [
      'العفو! 😊 سعيد جداً بمساعدتك، هل تريد معرفة شيء آخر؟',
      'لا شكر على واجب! 🌟 أنا هنا دائماً لمساعدتك في التخطيط لرحلتك',
      'أهلاً وسهلاً! 💙 إذا احتجت أي معلومة أخرى، لا تتردد في السؤال',
    ],
    'unknown': [
      'سؤال مثير للاهتمام! 🤔 دعني أساعدك بأفضل ما أستطيع...',
      'هذا سؤال رائع! 💭 سأحاول تقديم أفضل المعلومات المتاحة...',
      'أقدر فضولك! 🌟 دعني أشارك معك ما أعرفه عن هذا الموضوع...',
    ],
  };

  factory TourismChatbot([String? modelPath]) => getInstance(modelPath);
  TourismChatbot._internal();

  static TourismChatbot getInstance([String? modelPath]) {
    if (_instance._tourismData.isEmpty) {
      _instance._init(modelPath);
    }
    return _instance;
  }

  Future<void> _init(String? modelPath) async {
    try {
      print('Initializing TourismChatbot with model at $modelPath');
      final String jsonString = await rootBundle.loadString(
        'assets/data/tourism_data.json',
      );
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _tourismData =
          jsonData.map((data) => TourismData.fromJson(data)).toList();
      print('Tourism data loaded successfully');
    } catch (e) {
      print('Error loading tourism data: $e');
      modelAvailable = false;
      fallbackMode = true;
    }
  }

  // تحسين دالة البحث عن السياق
  String? findRelevantContext(String question) {
    try {
      final questionLower = question.toLowerCase();
      final keywords = questionLower.split(' ');

      // البحث المباشر في الوجهات
      for (var tourismData in _tourismData) {
        if (_containsDestination(questionLower, tourismData.destination)) {
          return tourismData.context;
        }
      }

      // البحث في المعالم
      for (var landmark in _egyptianLandmarks.entries) {
        final landmarkKeywords = landmark.value['keywords'] as List<String>;
        if (landmarkKeywords.any(
          (keyword) => questionLower.contains(keyword.toLowerCase()),
        )) {
          return landmark.value['responses'][0]; // إرجاع أول رد كسياق
        }
      }

      // البحث العميق في المحتوى
      for (var tourismData in _tourismData) {
        if (_hasRelevantContent(questionLower, tourismData)) {
          return tourismData.context;
        }
      }

      return null;
    } catch (e) {
      print('Error finding relevant context: $e');
      return null;
    }
  }

  // دالة مساعدة للبحث عن الوجهات
  bool _containsDestination(String question, String destination) {
    final destinationVariations = _getDestinationVariations(destination);
    return destinationVariations.any(
      (variation) => question.contains(variation.toLowerCase()),
    );
  }

  // إضافة تنويعات أسماء الوجهات
  List<String> _getDestinationVariations(String destination) {
    final variations = <String>[destination];

    switch (destination.toLowerCase()) {
      case 'cairo':
        variations.addAll(['القاهرة', 'قاهرة', 'cairo']);
        break;
      case 'luxor':
        variations.addAll(['الأقصر', 'أقصر', 'luxor', 'طيبة']);
        break;
      case 'alexandria':
        variations.addAll(['الإسكندرية', 'إسكندرية', 'alexandria', 'اسكندرية']);
        break;
      case 'aswan':
        variations.addAll(['أسوان', 'aswan']);
        break;
      case 'sharm el sheikh':
        variations.addAll(['شرم الشيخ', 'شرم', 'sharm']);
        break;
      case 'hurghada':
        variations.addAll(['الغردقة', 'غردقة', 'hurghada']);
        break;
    }

    return variations;
  }

  // فحص أعمق للمحتوى ذي الصلة
  bool _hasRelevantContent(String question, TourismData tourismData) {
    final allContent =
        [
          ...tourismData.attractions,
          ...tourismData.food,
          ...tourismData.transportation,
          tourismData.context,
        ].join(' ').toLowerCase();

    final questionWords = question.split(' ');
    int matchCount = 0;

    for (String word in questionWords) {
      if (word.length > 2 && allContent.contains(word.toLowerCase())) {
        matchCount++;
      }
    }

    return matchCount >= 2; // على الأقل كلمتين متطابقتين
  }

  // تحسين دالة توليد الردود
  String generateResponse(
    String question, {
    String? context,
    int maxLength = 200,
  }) {
    // حفظ السؤال في التاريخ
    _previousQuestions.add(question.toLowerCase());
    if (_previousQuestions.length > 10) {
      _previousQuestions.removeAt(0);
    }

    return _generateImprovedResponse(question, context);
  }

  String _generateImprovedResponse(String question, String? context) {
    final questionLower = question.toLowerCase();

    // التعامل مع التحيات
    if (_isGreeting(questionLower)) {
      return _getRandomResponse('greeting');
    }

    // التعامل مع الشكر
    if (_isThanking(questionLower)) {
      return _getRandomResponse('thanks');
    }

    // البحث في المعالم مع ردود متنوعة
    for (var landmark in _egyptianLandmarks.entries) {
      final landmarkData = landmark.value;
      final keywords = landmarkData['keywords'] as List<String>;

      if (keywords.any(
        (keyword) => questionLower.contains(keyword.toLowerCase()),
      )) {
        final responses = landmarkData['responses'] as List<String>;
        final suggestions = landmarkData['suggestions'] as List<String>;

        return _buildResponseWithSuggestions(
          _getRandomFromList(responses),
          suggestions,
        );
      }
    }

    // ردود محسنة للوجهات
    for (var tourismData in _tourismData) {
      if (_containsDestination(questionLower, tourismData.destination)) {
        return _generateDestinationResponse(questionLower, tourismData);
      }
    }

    // ردود للمواضيع العامة
    if (_isGeneralTravelQuestion(questionLower)) {
      return _generateGeneralTravelResponse(questionLower);
    }

    // رد افتراضي محسن
    return _generateDefaultResponse();
  }

  // دالة لتوليد ردود مخصصة للوجهات
  String _generateDestinationResponse(
    String question,
    TourismData tourismData,
  ) {
    final destination = tourismData.destination;

    if (_isAsking(question, [
      'معالم',
      'أماكن',
      'زيارة',
      'شاهد',
      'attractions',
      'visit',
      'see',
    ])) {
      final attractions = tourismData.attractions.take(4).toList();
      return '''✨ $destination مليانة أماكن رائعة!

🏛️ أهم المعالم:
${attractions.map((a) => '• $a').join('\n')}

${_getRandomEncouragement()} هل تريد تفاصيل أكثر عن أي معلم؟''';
    }

    if (_isAsking(question, [
      'فنادق',
      'إقامة',
      'hotels',
      'stay',
      'accommodation',
    ])) {
      final hotels = tourismData.hotels.take(3).toList();
      return '''🏨 فنادق مميزة في $destination:

${hotels.map((h) => '⭐ $h').join('\n')}

💡 نصيحة: احجز مبكراً خاصة في موسم الذروة (أكتوبر - أبريل)!''';
    }

    if (_isAsking(question, [
      'أكل',
      'طعام',
      'مطاعم',
      'food',
      'eat',
      'restaurant',
    ])) {
      final foods = tourismData.food.take(4).toList();
      return '''🍽️ لازم تجرب الأكلات دي في $destination:

${foods.map((f) => '🥘 $f').join('\n')}

😋 كل الأكلات دي من التراث المصري الأصيل!''';
    }

    if (_isAsking(question, [
      'وقت',
      'متى',
      'موسم',
      'weather',
      'when',
      'time',
    ])) {
      return '''🌤️ أحسن وقت لزيارة $destination:

📅 ${tourismData.bestTime}

☀️ الجو هيكون معتدل ومناسب للتنزه والاستمتاع بالمعالم!''';
    }

    if (_isAsking(question, ['مواصلات', 'نقل', 'transport', 'bus', 'taxi'])) {
      final transport = tourismData.transportation.take(4).toList();
      return '''🚗 وسائل المواصلات في $destination:

${transport.map((t) => '🚌 $t').join('\n')}

💡 نصيحة: استخدم أوبر أو كريم للراحة والأمان!''';
    }

    // رد عام عن الوجهة
    return '''🌟 $destination وجهة سياحية رائعة!

${tourismData.context.substring(0, min(200, tourismData.context.length))}...

🔍 اسألني عن:
• المعالم السياحية
• الفنادق والإقامة  
• الأكلات المحلية
• أفضل وقت للزيارة''';
  }

  // فحص أنواع الأسئلة
  bool _isAsking(String question, List<String> keywords) {
    return keywords.any((keyword) => question.contains(keyword));
  }

  bool _isGreeting(String question) {
    final greetings = [
      'مرحبا',
      'أهلا',
      'السلام',
      'hello',
      'hi',
      'hey',
      'صباح',
      'مساء',
    ];
    return greetings.any((greeting) => question.contains(greeting));
  }

  bool _isThanking(String question) {
    final thanks = ['شكرا', 'thank', 'thanks', 'متشكر', 'مشكور'];
    return thanks.any((thank) => question.contains(thank));
  }

  bool _isGeneralTravelQuestion(String question) {
    final travelKeywords = [
      'سفر',
      'رحلة',
      'سياحة',
      'travel',
      'trip',
      'tour',
      'vacation',
    ];
    return travelKeywords.any((keyword) => question.contains(keyword));
  }

  // دالة للردود العامة عن السفر
  String _generateGeneralTravelResponse(String question) {
    final generalResponses = [
      '''🇪🇬 مصر بلد الحضارة والجمال!

✨ تقدر تستمتع بـ:
• الآثار الفرعونية في القاهرة والأقصر
• الشواطئ الخلابة في البحر الأحمر
• الثقافة النوبية في أسوان
• الطبيعة الصحراوية الساحرة

🗺️ محتاج مساعدة في التخطيط لرحلتك؟''',

      '''🌟 السياحة في مصر تجربة فريدة!

🏺 اكتشف:
• عجائب الدنيا السبع (الأهرامات)
• أجمل معابد العالم في الأقصر
• أروع مواقع الغوص في شرم الشيخ
• سحر الصحراء البيضاء

💭 إيه اللي عايز تعرفه أكتر؟''',
    ];

    return _getRandomFromList(generalResponses);
  }

  // دالة للرد الافتراضي المحسن
  String _generateDefaultResponse() {
    final responses = [
      '''🤔 سؤال مثير للاهتمام!

أنا خبير السياحة المصرية، يمكنني مساعدتك في:
🏛️ معلومات عن المعالم الأثرية
🏨 نصائح الإقامة والفنادق
🍽️ الأكلات المحلية الشهية
🚗 وسائل المواصلات والتنقل

✨ جرب تسأل عن أي مدينة مصرية!''',

      '''🌟 أهلاً بك في دليل السياحة المصرية!

💡 يمكنك سؤالي عن:
• القاهرة والأهرامات الشهيرة
• الأقصر ووادي الملوك
• أسوان والثقافة النوبية
• شرم الشيخ والغوص
• الإسكندرية عروس البحر المتوسط

🗣️ اسأل عن أي حاجة تخص السفر في مصر!''',
    ];

    return _getRandomFromList(responses);
  }

  // دوال مساعدة
  String _getRandomResponse(String type) {
    final responses = _responsePatterns[type] ?? ['مرحباً بك!'];
    return _getRandomFromList(responses);
  }

  String _getRandomFromList(List<String> list) {
    if (list.isEmpty) return 'مرحباً بك!';
    return list[_random.nextInt(list.length)];
  }

  String _getRandomEncouragement() {
    final encouragements = [
      'كلها أماكن تستاهل الزيارة! 🌟',
      'مناظر خلابة مستنياك! ✨',
      'تجربة هتفضل في ذاكرتك! 💫',
      'استعد لرحلة لا تُنسى! 🎉',
    ];
    return _getRandomFromList(encouragements);
  }

  String _buildResponseWithSuggestions(
    String response,
    List<String> suggestions,
  ) {
    return '''$response

🔍 مواضيع قد تهمك:
${suggestions.take(3).map((s) => '• $s').join('\n')}''';
  }

  // رسالة الترحيب المحسنة
  static ChatMessage getWelcomeMessage() {
    final welcomeMessages = [
      '''أهلاً وسهلاً! 🇪🇬✨

أنا مرشدك السياحي الذكي لاستكشاف جمال مصر الخالد!
كيف يمكنني مساعدتك اليوم؟''',

      '''مرحباً بك في رحلة استكشاف مصر! 🏺🌟

سعيد جداً بلقائك! أنا هنا لأساعدك في التخطيط لأفضل رحلة سياحية.
ما الذي تود معرفته؟''',
    ];

    final random = Random();
    final selectedMessage =
        welcomeMessages[random.nextInt(welcomeMessages.length)];

    return ChatMessage(
      type: 'bot',
      message: selectedMessage,
      timestamp: DateTime.now(),
      suggestions: [
        'الأهرامات وأبو الهول 🏺',
        'رحلة نيلية في الأقصر 🚢',
        'الغوص في البحر الأحمر 🐠',
        'الصحراء البيضاء 🏜️',
        'أفضل المطاعم المصرية 🍽️',
        'نصائح السفر والإقامة 🏨',
      ],
    );
  }
}
