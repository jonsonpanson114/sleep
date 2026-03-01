import 'package:flutter/material.dart' show TimeOfDay;
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/entities/routine_task.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/achievement_repository.dart';

class WebSettingsMock implements SettingsRepository {
  AppSettings _settings = AppSettings(
    bedtime: const TimeOfDay(hour: 22, minute: 30),
    wakeTime: const TimeOfDay(hour: 6, minute: 30),
    bedtimeNotificationEnabled: true,
    wakeNotificationEnabled: true,
    bedtimeReminderOffsetMinutes: 30,
  );

  @override
  Future<AppSettings?> getSettings() async {
    return _settings;
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
  }
}

class WebLogMock implements LogRepository {
  @override
  Future<DailyLog?> getLog(String dateKey) async => null;
  @override
  Future<DailyLog?> getTodayLog() async => null;
  @override
  Future<List<DailyLog>> getRecentLogs(int days) async => [];
  @override
  Future<List<DailyLog>> getLogsInRange(DateTime start, DateTime end) async => [];
  @override
  Future<void> saveLog(DailyLog log) async {}
  @override
  Stream<DailyLog?> watchTodayLog() => Stream.value(null);
}

class WebTaskMock implements TaskRepository {
  @override
  Future<List<RoutineTask>> getAllTasks() async => [];
  @override
  Future<List<RoutineTask>> getTasksByType(RoutineType type) async => [];
  @override
  Future<void> addTask(RoutineTask task) async {}
  @override
  Future<void> deleteTask(String id) async {}
  @override
  Future<void> reorderTasks(List<RoutineTask> tasks) async {}
}

class WebAchievementMock implements AchievementRepository {
  @override
  Future<List<String>> getUnlockedAchievementIds() async => [];
  @override
  Future<void> unlockAchievement(String id) async {}
  @override
  Future<bool> isUnlocked(String id) async => false;
}
