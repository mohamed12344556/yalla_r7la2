import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_constants.dart';
import '../../cache/shared_pref_helper.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    initializeLocale();
  }

  void initializeLocale() async {
    final savedLanguage = await SharedPrefHelper.getString(
      SharedPrefKeys.language,
    );
    print('Initial saved language: $savedLanguage');

    if (savedLanguage != null &&
        savedLanguage.isNotEmpty &&
        supportedLanguages.containsKey(savedLanguage)) {
      emit(Locale(savedLanguage));
    }

    print('LocaleCubit initialized with locale: ${state.languageCode}');
  }

  // قائمة اللغات المدعومة
  final Map<String, String> _supportedLanguages = {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'es': 'Español',
    'de': 'Deutsch',
    'it': 'Italiano',
    'pt': 'Português',
    'ru': 'Русский',
    'ja': '日本語',
    'ko': '한국어',
    'zh': '中文',
    'hi': 'हिन्दी',
  };

  Locale getInitialLocale() {
    final savedLanguage = SharedPrefHelper.getString(SharedPrefKeys.language);
    print('Initial saved language: $savedLanguage');

    if (savedLanguage != null &&
        savedLanguage.isNotEmpty &&
        supportedLanguages.containsKey(savedLanguage)) {
      return Locale(savedLanguage);
    }

    return const Locale('en'); // Default to English
  }

  void changeLanguage(String languageCode) {
    // التحقق من أن اللغة مدعومة
    if (!supportedLanguages.containsKey(languageCode)) {
      print('Unsupported language code: $languageCode');
      return;
    }

    print('Changing language to: $languageCode');
    final newLocale = Locale(languageCode);

    // حفظ اللغة محلياً
    SharedPrefHelper.setData(SharedPrefKeys.language, languageCode);

    // تحديث الحالة
    emit(newLocale);

    print('Language changed, new locale: ${newLocale.languageCode}');
  }

  void toggleLanguage() {
    // التبديل بين الإنجليزية والعربية فقط (للتوافق مع الكود القديم)
    final newLanguageCode = state.languageCode == 'en' ? 'ar' : 'en';
    changeLanguage(newLanguageCode);
  }

  String get currentLanguageName {
    return supportedLanguages[state.languageCode] ?? 'English';
  }

  // دالة للحصول على اسم اللغة الحالية
  String getCurrentLanguageDisplayName() {
    return supportedLanguages[state.languageCode] ?? 'English';
  }

  // دالة للحصول على قائمة اللغات المدعومة
  Map<String, String> get supportedLanguages => _supportedLanguages;

  // دالة للتحقق من أن اللغة مدعومة
  bool isLanguageSupported(String languageCode) {
    return supportedLanguages.containsKey(languageCode);
  }
}
