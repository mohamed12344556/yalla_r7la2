import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yalla_r7la2/core/api/api_config.dart';
import 'package:yalla_r7la2/features/chat/services/chat_bot_service.dart';

import 'core/di/dependency_injection.dart';
import 'core/utils/auth_guard.dart';
import 'core/utils/bloc_setup.dart';
import 'core/utils/global_error_handler.dart';
import 'travel_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة ChatBotService باستخدام ApiConfig
  final geminiApiKey = ApiConfig.getGeminiApiKey();

  if (geminiApiKey != null) {
    ChatBotService.initialize(geminiApiKey: geminiApiKey);
    log('✅ ChatBotService initialized with Gemini API');
  } else {
    ChatBotService.initialize();
    log('⚠️ ChatBotService initialized without Gemini API');
  }

  // طباعة حالة مفاتيح الـ API (اختياري)
  if (ApiConfig.isDevelopment) {
    ApiConfig.printApiKeysStatus();
  }

  // Initialize global error handler
  GlobalErrorHandler.initialize();

  try {
    await setupGetIt();
    log('GetIt setup completed successfully');
  } catch (e) {
    log('Error setting up GetIt: $e');
  }

  // Initialize BLoC system
  await initBloc();

  // Initialize Hydrated Bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );

  final initialRoute = await AuthGuard.getInitialRoute();
  log('Initial Route: $initialRoute');

  // Accept self-signed certificates globally (Development only!)
  HttpOverrides.global = MyHttpOverrides();

  runApp(TravelApp(initialRoute: initialRoute));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Test credentials:
// Email: a123@gmail.com
// Password: 123456789@mA
// m7m7
// mm111@gmail.com
// 01060796400