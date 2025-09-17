import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/test_model.dart';
import '../models/achievement_model.dart';

// User Provider
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      // In a real app, you'd parse JSON here
      // For now, we'll create a mock user
      state = UserModel(
        id: 'user_1',
        name: 'John Doe',
        age: 25,
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        region: 'Delhi',
        language: 'en',
        isDarkMode: false,
        createdAt: DateTime.now(),
      );
    }
  }

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user.toJson().toString());
    state = user;
  }

  Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    state = null;
  }
}

// Theme Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = !state;
    await prefs.setBool('isDarkMode', state);
  }
}

// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en');

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('language') ?? 'en';
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    state = language;
  }
}

// Test Results Provider
final testResultsProvider = StateNotifierProvider<TestResultsNotifier, List<TestResult>>((ref) {
  return TestResultsNotifier();
});

class TestResultsNotifier extends StateNotifier<List<TestResult>> {
  TestResultsNotifier() : super([]);

  Future<void> loadResults() async {
    // Mock data for now
    state = [
      TestResult(
        id: '1',
        userId: 'user_1',
        testType: TestType.verticalJump,
        score: 42.0,
        unit: 'cm',
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TestResult(
        id: '2',
        userId: 'user_1',
        testType: TestType.situps,
        score: 25.0,
        unit: 'reps',
        completedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  void addResult(TestResult result) {
    state = [...state, result];
  }
}

// Achievements Provider
final achievementsProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier();
});

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  AchievementsNotifier() : super([]);

  Future<void> loadAchievements() async {
    // Mock achievements
    state = [
      Achievement(
        id: '1',
        title: 'First Test',
        description: 'Complete your first fitness test',
        icon: '🏃‍♂️',
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 3)),
        category: 'milestone',
      ),
      Achievement(
        id: '2',
        title: 'Endurance Star',
        description: 'Run 2km in under 10 minutes',
        icon: '⭐',
        isUnlocked: false,
        category: 'performance',
      ),
      Achievement(
        id: '3',
        title: 'Jump Master',
        description: 'Achieve 50cm vertical jump',
        icon: '🦘',
        isUnlocked: false,
        category: 'performance',
      ),
    ];
  }

  void unlockAchievement(String achievementId) {
    state = state.map((achievement) {
      if (achievement.id == achievementId && !achievement.isUnlocked) {
        return achievement.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
      }
      return achievement;
    }).toList();
  }
}

// Leaderboard Provider
final leaderboardProvider = StateNotifierProvider<LeaderboardNotifier, List<LeaderboardEntry>>((ref) {
  return LeaderboardNotifier();
});

class LeaderboardNotifier extends StateNotifier<List<LeaderboardEntry>> {
  LeaderboardNotifier() : super([]);

  Future<void> loadLeaderboard() async {
    // Mock leaderboard data
    state = [
      LeaderboardEntry(
        userId: 'user_2',
        name: 'Alice Johnson',
        region: 'Mumbai',
        score: 95.5,
        rank: 1,
      ),
      LeaderboardEntry(
        userId: 'user_1',
        name: 'John Doe',
        region: 'Delhi',
        score: 87.2,
        rank: 2,
      ),
      LeaderboardEntry(
        userId: 'user_3',
        name: 'Bob Smith',
        region: 'Bangalore',
        score: 82.1,
        rank: 3,
      ),
    ];
  }
}
