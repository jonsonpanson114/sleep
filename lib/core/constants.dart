import 'package:flutter/material.dart';

/// カラーパレット
class AppColors {
  static const background = Color(0xFF0D1117);
  static const cardBackground = Color(0xFF161B22);
  static const primary = Color(0xFF1A237E);
  static const accent = Color(0xFFFFB300);
  static const textPrimary = Color(0xFFDDEEFF);
  static const textSecondary = Color(0xFF80AABB);
  static const success = Color(0xFF00BFA5);
  static const danger = Color(0xFFEF5350);
  static const badgeUnlocked = Color(0xFFFFD700);
  static const badgeLocked = Color(0xFF484848);
  static const insightPositive = Color(0xFF00BFA5);
  static const insightWarning = Color(0xFFFF6D00);

  // おやすみモード背景色（タスク完了率に応じて変化）
  static const List<Color> nightModeBackgrounds = [
    Color(0xFF0D1117),  // 0% 完了
    Color(0xFF0B1221),  // 33% 完了
    Color(0xFF09122B),  // 67% 完了
    Color(0xFF051530),  // 100% 完了
  ];
}

/// 通知ID
class NotificationIds {
  static const bedtimeReminder = 1;
  static const wakeAlarm = 2;
}

/// バッジID
class AchievementIds {
  static const firstComplete = 'first_complete';
  static const streak7 = 'streak_7';
  static const streak30 = 'streak_30';
  static const streak100 = 'streak_100';
  static const noSleepiness7 = 'no_sleepiness_7';
  static const earlyBed7 = 'early_bed_7';
  static const perfectWeek4 = 'perfect_week_4';
}

/// Gemini API Configuration
class GeminiAPIConfig {
  static const enabled = false; // Set to true when API key is configured
  static const apiKey = ''; // Add your API key here or set via environment variable
  static const baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent';
  static const model = 'models/gemini-2.0-flash-exp';

  /// Check if API is properly configured
  static bool get isConfigured => enabled && apiKey.isNotEmpty;

  /// Get API key from environment variable or fallback to static key
  static String get apiKeyValue {
    if (apiKey.isNotEmpty) return apiKey;
    // Check environment variable (for future web deployment)
    return const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  }
}
