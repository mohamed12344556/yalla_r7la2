import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// ==================== ThemeCubit المحدث ====================
class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  // تغيير الثيم للوضع المحدد
  void changeTheme(ThemeMode mode) {
    emit(mode);
  }

  // تبديل بين Light و Dark (يتجاهل System)
  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
    } else {
      // لو كان system، يحول لـ dark
      emit(ThemeMode.dark);
    }
  }

  // تفعيل وضع النظام
  void useSystemTheme() {
    emit(ThemeMode.system);
  }

  // تحديد هل الثيم مظلم حالياً (مع مراعاة النظام)
  bool isDarkMode(BuildContext context) {
    switch (state) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  // الحصول على نص وصفي للحالة الحالية
  String getThemeDescription(BuildContext context) {
    switch (state) {
      case ThemeMode.light:
        return 'فاتح';
      case ThemeMode.dark:
        return 'مظلم';
      case ThemeMode.system:
        final isSystemDark =
            MediaQuery.of(context).platformBrightness == Brightness.dark;
        return 'تلقائي (${isSystemDark ? 'مظلم' : 'فاتح'})';
    }
  }

  final String _jsonKey = "themeMode";

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    switch (json[_jsonKey]) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      case "system":
      default:
        return ThemeMode.system;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    switch (state) {
      case ThemeMode.light:
        return {_jsonKey: "light"};
      case ThemeMode.dark:
        return {_jsonKey: "dark"};
      case ThemeMode.system:
        return {_jsonKey: "system"};
    }
  }
}
