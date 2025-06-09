import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:yalla_r7la2/features/chat/data/models/chat_models.dart';
import 'package:yalla_r7la2/features/chat/data/models/tourism_data.dart';

class TourismChatbot {
  static final TourismChatbot _instance = TourismChatbot._internal();
  static TourismChatbot get instance => _instance;
  List<TourismData> _tourismData = [];
  bool modelAvailable = false;
  bool fallbackMode = true;
  final Map<String, String> _egyptianLandmarks = {
    'pyramid':
        'Cairo is Egypt\'s capital and home to the Pyramids of Giza. The Great Pyramid of Khufu is the oldest and largest of the three pyramids in the Giza pyramid complex and is the oldest of the Seven Wonders of the Ancient World.',
    'sphinx':
        'The Great Sphinx of Giza is a limestone statue of a reclining sphinx, a mythical creature with the head of a human and the body of a lion. It stands on the Giza Plateau on the west bank of the Nile in Giza, Egypt.',
    'luxor':
        'Luxor, once the ancient city of Thebes, is often called the world\'s greatest open-air museum with its temples and tombs including the Valley of the Kings.',
    'karnak':
        'Karnak Temple Complex, commonly known as Karnak, comprises a vast mix of decayed temples, chapels, pylons, and other buildings near Luxor, Egypt.',
    'nile':
        'The Nile River is the longest river in Africa and has historically been considered the longest river in the world. It flows through 11 countries including Egypt.',
    'alexandria':
        'Alexandria is a Mediterranean port city in Egypt founded by Alexander the Great. It\'s known for its Bibliotheca Alexandrina and Qaitbay Citadel.',
    'khan el khalili':
        'Khan El Khalili is a famous bazaar and souq in the historic center of Islamic Cairo.',
    'valley of kings':
        'The Valley of the Kings is a valley in Egypt where rock-cut tombs were excavated for the pharaohs and powerful nobles of the New Kingdom.',
    'abu simbel':
        'Abu Simbel temples are two massive rock temples in southern Egypt, near the border with Sudan. They were originally carved out of the mountainside during the reign of Pharaoh Ramesses II.',
    'red sea':
        'Egypt\'s Red Sea coast is known for its beautiful beaches and coral reefs, making it a popular destination for diving and snorkeling.',
    'sharm el sheikh':
        'Sharm El Sheikh is an Egyptian resort town between the desert of the Sinai Peninsula and the Red Sea, known for its sheltered sandy beaches, clear waters, and coral reefs.',
    'hurghada':
        'Hurghada is a beach resort town stretching 40km along Egypt\'s Red Sea coast, renowned for scuba diving and vibrant nightlife.',
    'aswan':
        'Aswan is a city on the Nile River known for its beautiful Nile Valley scenery, significant archaeological sites, and its peaceful atmosphere.',
    'siwa':
        'Siwa Oasis is an urban oasis located between the Qattara Depression and the Great Sand Sea in Egypt\'s Western Desert.',
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
      if (modelPath != null) {
        print('Model path $modelPath not found, using fallback mode');
        modelAvailable = false;
        fallbackMode = true;
      } else {
        modelAvailable = false;
        fallbackMode = true;
      }
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

  String? findRelevantContext(String question) {
    try {
      final questionLower = question.toLowerCase();
      final keywords = questionLower.split(' ');

      for (var tourismData in _tourismData) {
        if (tourismData.destination.toLowerCase().contains(questionLower)) {
          return tourismData.context;
        }
      }

      for (var keyword in _egyptianLandmarks.keys) {
        if (questionLower.contains(keyword)) {
          return _egyptianLandmarks[keyword];
        }
      }

      for (var tourismData in _tourismData) {
        final contextLower = tourismData.context.toLowerCase();
        if (keywords.any((keyword) => contextLower.contains(keyword))) {
          return tourismData.context;
        }
      }

      return null;
    } catch (e) {
      print('Error finding relevant context: $e');
      return null;
    }
  }

  String generateResponse(
    String question, {
    String? context,
    int maxLength = 200,
  }) {
    if (!modelAvailable || fallbackMode) {
      return _generateFallbackResponse(question, context);
    }
    return _generateFallbackResponse(
      question,
      context,
    ); // No AI model, always use fallback
  }

  String _generateFallbackResponse(String question, String? context) {
    final questionLower = question.toLowerCase();

    if (questionLower.contains('pyramid') || questionLower.contains('giza')) {
      return 'The Pyramids of Giza are Egypt\'s most iconic monuments. The Great Pyramid of Khufu is the oldest of the Seven Wonders of the Ancient World and the only one still standing. The complex includes three main pyramids (Khufu, Khafre, and Menkaure), the Great Sphinx, and several cemeteries. The best time to visit is early morning or late afternoon to avoid crowds and heat. Entrance fees are approximately 200 EGP for the main area and additional fees for entering the pyramids themselves.';
    }

    if (questionLower.contains('sphinx')) {
      return 'The Great Sphinx of Giza is a limestone statue depicting a mythical creature with a lion\'s body and a human head. It stands on the Giza Plateau protecting the pyramid complex. It\'s believed to represent Pharaoh Khafre and dates back to around 2500 BCE. The Sphinx is 73 meters long and 20 meters high, making it one of the world\'s largest monolithic statues. It\'s included in the general Giza Plateau ticket, and the best viewing times are early morning or during the evening sound and light show.';
    }

    if (questionLower.contains('nile') || questionLower.contains('cruise')) {
      return 'A Nile cruise is one of the best ways to experience Egypt\'s ancient wonders. Most cruises operate between Luxor and Aswan, with stops at major temples like Karnak, Luxor, Edfu, Kom Ombo, and Philae. Cruises typically range from 3-7 nights, with luxury options available. The best time for a Nile cruise is between October and April when temperatures are pleasant. Many cruises include guided tours, meals, and entertainment. Prices vary depending on the season and level of luxury, starting from around \$100 per night.';
    }

    if (questionLower.contains('best time') ||
        questionLower.contains('when to visit')) {
      return 'The best time to visit Egypt is from October to April when temperatures are cooler and more comfortable for sightseeing. December and January are peak tourist months. Summer (May to September) can be extremely hot, especially in Upper Egypt (Luxor and Aswan), with temperatures exceeding 40°C. If you\'re planning to visit the Red Sea resorts like Sharm El Sheikh or Hurghada, they\'re enjoyable year-round with milder summer temperatures. Ramadan dates change each year and may affect opening hours and services, so check the calendar before planning your trip.';
    }

    if (questionLower.contains('red sea') ||
        questionLower.contains('diving') ||
        questionLower.contains('snorkeling')) {
      return 'Egypt\'s Red Sea coast offers some of the world\'s best diving and snorkeling experiences. Popular destinations include Sharm El Sheikh, Hurghada, Dahab, and Marsa Alam. The Red Sea features crystal clear waters, vibrant coral reefs, and diverse marine life including colorful fish, turtles, dolphins, and occasionally whale sharks. Famous dive sites include Ras Mohammed National Park, the Blue Hole in Dahab, Thistlegorm wreck, and the Brothers Islands. The water is warm year-round (22-29°C), making it suitable for diving in any season.';
    }

    if (questionLower.contains('food') ||
        questionLower.contains('cuisine') ||
        questionLower.contains('eat')) {
      return 'Egyptian cuisine offers delicious flavors with both Middle Eastern and Mediterranean influences. Must-try dishes include: Koshari (a mix of rice, lentils, pasta with tomato sauce and fried onions), Ful Medames (mashed fava beans with olive oil, lemon juice, and spices), Ta\'ameya (Egyptian falafel made from fava beans), Molokhia (jute leaf stew), Hawawshi (spiced minced meat in bread), and Mahshi (stuffed vegetables). For dessert, try Konafa, Basbousa, or Om Ali. Street food is abundant and affordable, while fresh juices like sugarcane and hibiscus tea (karkade) are popular beverages.';
    }

    if (questionLower.contains('cairo')) {
      return 'Cairo, Egypt\'s sprawling capital, is a vibrant metropolis blending ancient history with modern urban life. Must-see attractions include the Pyramids of Giza, the Egyptian Museum (or the new Grand Egyptian Museum when it opens), Khan el-Khalili bazaar, Al-Azhar Park, Saladin Citadel, and Coptic Cairo. The city is divided by the Nile River and has distinct neighborhoods like Downtown, Zamalek, Garden City, and Heliopolis. Cairo can be overwhelming with its traffic and noise, but it offers incredible cultural experiences, delicious food, and warm hospitality. The best way to get around is by using Uber or Careem, as they\'re more reliable than regular taxis.';
    }

    if (questionLower.contains('luxor')) {
      return 'Luxor, often called the world\'s greatest open-air museum, was the ancient city of Thebes and Egypt\'s capital during the New Kingdom. The city is divided by the Nile River: the East Bank features Luxor Temple and the massive Karnak Temple complex, while the West Bank houses the Valley of the Kings (where Tutankhamun\'s tomb was discovered), Valley of the Queens, and the Temple of Hatshepsut. Don\'t miss the Luxor Museum and the Sound and Light shows at Karnak. The best way to explore is by hiring a guide, and consider taking a hot air balloon ride at sunrise for a spectacular view of the monuments and the Nile Valley.';
    }

    if (questionLower.contains('alexandria')) {
      return 'Alexandria, founded by Alexander the Great in 331 BCE, is Egypt\'s second-largest city and main Mediterranean seaport. Unlike other Egyptian cities, Alexandria has a distinctly Mediterranean atmosphere with its seafront Corniche, beaches, and Greco-Roman heritage. Key attractions include the modern Bibliotheca Alexandrina, Qaitbay Citadel built on the ruins of the ancient Lighthouse, Pompey\'s Pillar, the Catacombs of Kom El Shoqafa, and Montaza Palace gardens. The city is known for its excellent seafood restaurants, colonial-era cafés, and pleasant weather, especially in summer when it\'s cooler than Cairo. It makes a perfect day trip or weekend getaway from Cairo.';
    }

    for (var tourismData in _tourismData) {
      final destinationLower = tourismData.destination.toLowerCase();
      if (questionLower.contains(destinationLower)) {
        if ([
          'see',
          'visit',
          'attraction',
          'sight',
        ].any((word) => questionLower.contains(word))) {
          final attractions = tourismData.attractions.take(5).join(', ');
          return 'In ${tourismData.destination}, you should definitely visit $attractions. These are some of the most iconic places that showcase Egypt\'s rich history and culture. I recommend spending at least 2-3 days to properly explore these attractions.';
        }
        if ([
          'stay',
          'hotel',
          'accommodation',
        ].any((word) => questionLower.contains(word))) {
          final hotels = tourismData.hotels.take(5).join(', ');
          return 'For accommodations in ${tourismData.destination}, I would recommend $hotels. These range from luxury to boutique options depending on your budget. It\'s advisable to book in advance, especially during the high season (October to April).';
        }
        if ([
          'eat',
          'food',
          'restaurant',
          'cuisine',
        ].any((word) => questionLower.contains(word))) {
          final foods = tourismData.food.take(5).join(', ');
          return 'When in ${tourismData.destination}, make sure to try $foods. These local Egyptian dishes will give you an authentic taste of the local cuisine. Street food is generally safe in tourist areas, but always ensure it\'s freshly prepared and hot.';
        }
        if ([
          'when',
          'time',
          'season',
          'month',
          'weather',
        ].any((word) => questionLower.contains(word))) {
          return 'The best time to visit ${tourismData.destination} is ${tourismData.bestTime}. Egypt has a desert climate, so be prepared for hot days and cooler nights. Always carry water, sunscreen, and a hat when sightseeing.';
        }
        if ([
          'transport',
          'get around',
          'bus',
          'train',
        ].any((word) => questionLower.contains(word))) {
          final transport = tourismData.transportation.take(5).join(', ');
          return 'Getting around ${tourismData.destination} is easy using $transport. For taxis, it\'s best to use ride-hailing apps like Uber or Careem. If you\'re traveling between cities, domestic flights, trains, and tourist buses are available options.';
        }
        return '${tourismData.destination} is a wonderful Egyptian destination! Some top attractions include ${tourismData.attractions.take(3).join(', ')}. The best time to visit is ${tourismData.bestTime}. What specific information are you looking for about ${tourismData.destination}?';
      }
    }

    if (questionLower.contains('recommend') ||
        questionLower.contains('suggestion') ||
        questionLower.contains('where')) {
      return 'Egypt offers diverse experiences for travelers! For ancient history, Cairo (Pyramids, Egyptian Museum) and Luxor (Valley of the Kings, Karnak Temple) are must-visits. For beach and diving, head to the Red Sea resorts of Sharm El Sheikh or Hurghada. Alexandria offers Mediterranean charm with Greco-Roman ruins. For a unique experience, visit the White Desert or Siwa Oasis. A Nile cruise between Luxor and Aswan lets you see multiple ancient sites while enjoying the river scenery. Most first-time visitors spend 7-10 days covering Cairo, Luxor, and either Aswan or a Red Sea resort.';
    }

    if (questionLower.contains('budget') ||
        questionLower.contains('cheap') ||
        questionLower.contains('expensive') ||
        questionLower.contains('cost')) {
      return 'Egypt can be quite affordable compared to many destinations. Budget travelers can get by on \$30-50 per day with basic accommodations, street food, and public transportation. Mid-range travelers should budget \$100-150 daily for better hotels and restaurants. Luxury experiences start from \$200-300 per day. Entrance fees to major attractions range from 100-400 EGP (\$3-13). A Nile cruise costs \$100-300 per night depending on luxury level. Tipping (baksheesh) is expected for most services. The Egyptian Pound (EGP) is the local currency, and while credit cards are accepted at hotels and larger restaurants, having cash is essential for smaller establishments and markets.';
    }

    if (questionLower.contains('safety')) {
      return 'Egypt is generally safe for tourists, especially in the main tourist areas which have increased security. Like any destination, take normal precautions: watch your belongings, avoid isolated areas at night, and be aware of common scams targeting tourists. It\'s advisable to drink bottled water, use reputable tour operators, and respect local customs regarding dress and behavior. Women travelers should dress modestly, especially in non-resort areas. Stay updated on travel advisories, and consider hiring local guides for the best experience. Most Egyptians are friendly and welcoming to tourists, as tourism is a vital part of the economy.';
    }

    return 'I\'d be happy to help with your Egypt travel plans. You can ask me about popular Egyptian destinations like Cairo, Luxor, Alexandria, Aswan, or the Red Sea resorts. I can provide information about the pyramids, ancient temples, best times to visit, accommodations, local food, or transportation options. What specific aspect of Egyptian tourism would you like to know about?';
  }

  static ChatMessage getWelcomeMessage() {
    return ChatMessage(
      type: 'bot',
      message: '''مرحباً بك! 👋
أنا مساعدك الذكي للسفر والسياحة. كيف يمكنني مساعدتك اليوم؟''',
      timestamp: DateTime.now(),
      suggestions: [
        'أماكن سياحية مميزة',
        'نصائح السفر',
        'حجز الرحلات',
        'معلومات عن الفنادق',
      ],
    );
  }
}
