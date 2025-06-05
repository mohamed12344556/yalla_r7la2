import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:yalla_r7la2/core/themes/cubit/theme_cubit.dart';

import 'core/routes/app_router.dart';
import 'core/themes/app_theme.dart';

final sl = GetIt.instance;

class TravelApp extends StatelessWidget {
  final String initialRoute;

  const TravelApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Travel Explorer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: initialRoute,
          );
        },
      ),
    );
  }
}
