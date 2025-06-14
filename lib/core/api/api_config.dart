class ApiConfig {
  // مفاتيح الـ API - يجب عدم رفع هذا الملف إلى Git
  static const String geminiApiKey = 'AIzaSyBIeBXCtFx-VGCpRH8taVJF38xuKx_HaPM';

  // يمكنك إضافة مفاتيح API أخرى هنا
  static const String openWeatherApiKey = '';
  static const String mapBoxApiKey = '';

  // إعدادات أخرى
  static const bool isDevelopment = true;

  // التحقق من صحة مفاتيح الـ API
  static bool get hasGeminiApiKey => geminiApiKey.isNotEmpty;
  static bool get hasOpenWeatherApiKey => openWeatherApiKey.isNotEmpty;
  static bool get hasMapBoxApiKey => mapBoxApiKey.isNotEmpty;

  // الحصول على مفتاح Gemini مع التحقق
  static String? getGeminiApiKey() {
    if (geminiApiKey.isEmpty) {
      print('⚠️ تحذير: مفتاح Gemini API غير موجود');
      return null;
    }
    return geminiApiKey;
  }

  // طباعة حالة جميع مفاتيح الـ API
  static void printApiKeysStatus() {
    print('📊 حالة مفاتيح الـ API:');
    print('  • Gemini API: ${hasGeminiApiKey ? "✅ متوفر" : "❌ غير متوفر"}');
    print(
      '  • OpenWeather API: ${hasOpenWeatherApiKey ? "✅ متوفر" : "❌ غير متوفر"}',
    );
    print('  • MapBox API: ${hasMapBoxApiKey ? "✅ متوفر" : "❌ غير متوفر"}');
  }
}
