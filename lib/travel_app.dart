import 'package:flutter/material.dart';
import 'package:p1/core/routes/app_router.dart';
import 'package:p1/core/themes/app_theme.dart';

class TravelApp extends StatelessWidget {
  final String initialRoute;

  const TravelApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: initialRoute,
      // initialRoute: Routes.host,
    );
  }
}
