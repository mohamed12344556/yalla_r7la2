import 'dart:developer';

import 'package:p1/core/api/api_constants.dart';
import 'package:p1/core/cache/shared_pref_helper.dart';
import 'package:p1/core/routes/routes.dart';

class AuthGuard {
  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.token);
    log('Token from SharedPrefs: ${token.isNotEmpty ? "EXISTS ✅" : "EMPTY ❌"}');
    return token.isNotEmpty;
  }

  // Get initial route based on auth status
  static Future<String> getInitialRoute() async {
    final isAuthenticated = await isLoggedIn();
    final route = !isAuthenticated ? Routes.login : Routes.host;
    log('User authenticated: $isAuthenticated, Route: $route');
    return route;
  }

  // Logout user
  static Future<void> logout() async {
    await SharedPrefHelper.clearAllData();
    await SharedPrefHelper.clearAllSecuredData();
    log('User logged out');
  }

  // Check if this is first time user
  static Future<bool> isFirstTime() async {
    final isFirst = await SharedPrefHelper.getBool(SharedPrefKeys.isFirstTime);
    log('Is first time: ${!isFirst}');
    return !isFirst; // Returns true if it's first time (default false)
  }

  // Set first time to false
  static Future<void> setNotFirstTime() async {
    await SharedPrefHelper.setData(SharedPrefKeys.isFirstTime, true);
    log('First time set to false');
  }
}
