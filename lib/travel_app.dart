import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'core/themes/cubit/locale_cubit.dart';
import 'core/themes/cubit/theme_cubit.dart';
import 'core/utils/languages.dart';
import 'generated/l10n.dart';

import 'core/routes/app_router.dart';
import 'core/themes/app_theme.dart';

final sl = GetIt.instance;

class TravelApp extends StatelessWidget {
  final String initialRoute;
  const TravelApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ThemeCubit>()),
        BlocProvider.value(value: sl<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                title: 'Travel Explorer',
                debugShowCheckedModeBanner: false,
                locale: locale, 
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: Languages.all,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                onGenerateRoute: AppRouter.generateRoute,
                initialRoute: initialRoute,
              );
            },
          );
        },
      ),
    );
  }
}
