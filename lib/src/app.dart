import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'providers/app_providers.dart';
import 'navigation/app_router.dart';

class SAIApp extends ConsumerStatefulWidget {
  const SAIApp({super.key});

  @override
  ConsumerState<SAIApp> createState() => _SAIAppState();
}

class _SAIAppState extends ConsumerState<SAIApp> {
  @override
  void initState() {
    super.initState();
    // Initialize providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(themeProvider.notifier).loadTheme();
      ref.read(languageProvider.notifier).loadLanguage();
      ref.read(userProvider.notifier).loadUser();
      ref.read(testResultsProvider.notifier).loadResults();
      ref.read(achievementsProvider.notifier).loadAchievements();
      ref.read(leaderboardProvider.notifier).loadLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final language = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'SAI Talent Assessment',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: AppRouter.router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('hi', ''),
      ],
      locale: Locale(language),
      debugShowCheckedModeBanner: false,
    );
  }
}


