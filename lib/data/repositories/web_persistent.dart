import 'dart:convert';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/entities/routine_task.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/achievement_repository.dart';

class WebSettingsPersistent implements SettingsRepository {
  static const _key = 'app_settings';

  @override
  Future<AppSettings?> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) {
      // デフォルト設定を返す
      return const AppSettings(
        bedtime: TimeOfDay(hour: 23, minute: 0),
        wakeTime: TimeOfDay(hour: 7, minute: 0),
        bedtimeNotificationEnabled: true,
        wakeNotificationEnabled: true,
        bedtimeReminderOffsetMinutes: 30,
      );
    }

    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return AppSettings(
      bedtime: TimeOfDay(hour: map['bedtimeHour'], minute: map['bedtimeMinute']),
      wakeTime: TimeOfDay(hour: map['wakeHour'], minute: map['wakeMinute']),
      bedtimeNotificationEnabled: map['bedtimeNotif'],
      wakeNotificationEnabled: map['wakeNotif'],
      bedtimeReminderOffsetMinutes: map['offset'],
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'bedtimeHour': settings.bedtime.hour,
      'bedtimeMinute': settings.bedtime.minute,
      'wakeHour': settings.wakeTime.hour,
      'wakeMinute': settings.wakeTime.minute,
      'bedtimeNotif': settings.bedtimeNotificationEnabled,
      'wakeNotif': settings.wakeNotificationEnabled,
      'offset': settings.bedtimeReminderOffsetMinutes,
    };
    await prefs.setString(_key, jsonEncode(map));
  }
}

class WebLogPersistent implements LogRepository {
  static const _keyPrefix = 'daily_log_';

  @override
  Future<DailyLog?> getLog(String dateKey) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('$_keyPrefix$dateKey');
    if (jsonStr == null) return null;

    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return DailyLog(
      date: DateTime.parse(map['date']),
      completedTaskIds: (map['completedTaskIds'] as List).cast<String>(),
      eveningCompleted: map['eveningCompleted'] ?? false,
      morningCompleted: map['morningCompleted'] ?? false,
      eveningCompletedAt: map['eveningCompletedAt'] != null 
          ? DateTime.parse(map['eveningCompletedAt']) : null,
      morningCompletedAt: map['morningCompletedAt'] != null 
          ? DateTime.parse(map['morningCompletedAt']) : null,
      napTaken: map['napTaken'],
      daytimeSleepiness: map['daytimeSleepiness'],
      feltIrritable: map['feltIrritable'],
      dreamNote: map['dreamNote'],
    );
  }

  @override
  Future<DailyLog?> getTodayLog() async {
    final now = DateTime.now();
    final key = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return getLog(key);
  }

  @override
  Future<void> saveLog(DailyLog log) async {
    final prefs = await SharedPreferences.getInstance();
    final now = log.date;
    final key = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    final map = {
      'date': log.date.toIso8601String(),
      'completedTaskIds': log.completedTaskIds,
      'eveningCompleted': log.eveningCompleted,
      'morningCompleted': log.morningCompleted,
      'eveningCompletedAt': log.eveningCompletedAt?.toIso8601String(),
      'morningCompletedAt': log.morningCompletedAt?.toIso8601String(),
      'napTaken': log.napTaken,
      'daytimeSleepiness': log.daytimeSleepiness,
      'feltIrritable': log.feltIrritable,
      'dreamNote': log.dreamNote,
    };
    await prefs.setString('$_keyPrefix$key', jsonEncode(map));
  }

  @override
  Future<List<DailyLog>> getRecentLogs(int days) async {
    // Simplified for web mock-persistence
    return [];
  }

  @override
  Future<List<DailyLog>> getLogsInRange(DateTime start, DateTime end) async {
    return [];
  }

  @override
  Stream<DailyLog?> watchTodayLog() => Stream.fromFuture(getTodayLog());
}

class WebTaskPersistent implements TaskRepository {
  // Use a hardcoded list for now or expand to persistence if needed
  final List<RoutineTask> _defaultTasks = [
    const RoutineTask(id: 'e1', title: 'スマホを置く', type: RoutineType.evening, sortOrder: 0),
    const RoutineTask(id: 'e2', title: 'ストレッチ', type: RoutineType.evening, sortOrder: 1),
    const RoutineTask(id: 'm1', title: '太陽の光を浴びる', type: RoutineType.morning, sortOrder: 0),
    const RoutineTask(id: 'm2', title: 'コップ一杯の水を飲む', type: RoutineType.morning, sortOrder: 1),
  ];

  @override
  Future<List<RoutineTask>> getAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('routine_tasks');
    if (jsonStr == null) return _defaultTasks;

    final List list = jsonDecode(jsonStr);
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return RoutineTask(
        id: map['id'],
        title: map['title'],
        type: RoutineType.values.firstWhere((e) => e.toString() == map['type']),
        sortOrder: map['sortOrder'],
      );
    }).toList();
  }

  @override
  Future<List<RoutineTask>> getTasksByType(RoutineType type) async {
    final all = await getAllTasks();
    return all.where((t) => t.type == type).toList();
  }
  @override
  Future<void> addTask(RoutineTask task) async {}
  @override
  Future<void> deleteTask(String id) async {}
  @override
  Future<void> reorderTasks(List<RoutineTask> tasks) async {}
}

class WebAchievementPersistent implements AchievementRepository {
  @override
  Future<List<String>> getUnlockedAchievementIds() async => [];
  @override
  Future<void> unlockAchievement(String id) async {}
  @override
  Future<bool> isUnlocked(String id) async => false;
}
