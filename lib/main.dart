import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:p1/core/di/dependency_injection.dart';
import 'package:p1/core/utils/auth_guard.dart';
import 'package:p1/core/utils/bloc_setup.dart';
import 'package:p1/travel_app.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
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
  runApp(TravelApp(initialRoute: initialRoute));
}
// Test credentials:
// Email: a123@gmail.com
// Password: 123456789@mA
// m7m7
// mm111@gmail.com
// 01060796400