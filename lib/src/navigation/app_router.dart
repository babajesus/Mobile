import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_providers.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/home_screen.dart';
import '../screens/test_selection_screen.dart';
import '../screens/record_screen.dart';
import '../screens/results_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/registration',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/test-selection',
        builder: (context, state) => const TestSelectionScreen(),
      ),
      GoRoute(
        path: '/record/:testType',
        builder: (context, state) {
          final testType = state.pathParameters['testType']!;
          return RecordScreen(testType: testType);
        },
      ),
      GoRoute(
        path: '/results/:testType/:score',
        builder: (context, state) {
          final testType = state.pathParameters['testType']!;
          final score = double.parse(state.pathParameters['score']!);
          return ResultsScreen(testType: testType, score: score);
        },
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    redirect: (context, state) {
      // Add authentication logic here if needed
      return null;
    },
  );
}
