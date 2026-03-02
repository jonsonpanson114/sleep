import 'dart:convert';
import 'dart:async';
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
  final _controller = StreamController<AppSettings?>.broadcast();

  @override
  Future<AppSettings?> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) {
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
    _controller.add(settings);
  }
}

class WebLogPersistent implements LogRepository {
  static const _keyPrefix = 'daily_log_';
  final _controller = StreamController<DailyLog?>.broadcast();

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
    
    // 現在のログが更新されたことを通知
    final today = DateTime.now();
    if (log.date.year == today.year && log.date.month == today.month && log.date.day == today.day) {
      _controller.add(log);
    }
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
  Stream<DailyLog?> watchTodayLog() {
    // 初回データを流しつつ、その後の更新を待機
    Timer.run(() async {
      final log = await getTodayLog();
      _controller.add(log);
    });
    return _controller.stream;
  }
}

class WebTaskPersistent implements TaskRepository {
  final _controller = StreamController<List<RoutineTask>>.broadcast();
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
    if (jsonStr == null) return List.from(_defaultTasks);

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

  Stream<List<RoutineTask>> watchTasksByType(RoutineType type) {
    Timer.run(() => _emitCurrentTasks());
    
    return _controller.stream.map((allTasks) {
      return allTasks.where((t) => t.type == type).toList();
    });
  }

  void _emitCurrentTasks() async {
    final tasks = await getAllTasks();
    _controller.add(tasks);
  }

  @override
  Future<void> addTask(RoutineTask task) async {
    final tasks = await getAllTasks();
    tasks.add(task);
    await _saveAllTasks(tasks);
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((t) => t.id == id);
    await _saveAllTasks(tasks);
  }

  @override
  Future<void> reorderTasks(List<RoutineTask> tasks) async {
    await _saveAllTasks(tasks);
  }

  Future<void> _saveAllTasks(List<RoutineTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks.map((t) => {
      'id': t.id,
      'title': t.title,
      'type': t.type.toString(),
      'sortOrder': t.sortOrder,
    }).toList();
    await prefs.setString('routine_tasks', jsonEncode(jsonList));
    _controller.add(tasks); // 監視者に通知
  }
}


class WebAchievementPersistent implements AchievementRepository {
  static const _key = 'unlocked_achievements';

  @override
  Future<List<String>> getUnlockedAchievementIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  @override
  Future<void> unlockAchievement(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getUnlockedAchievementIds();
    if (!current.contains(id)) {
      current.add(id);
      await prefs.setStringList(_key, current);
    }
  }

  @override
  Future<bool> isUnlocked(String id) async {
    final current = await getUnlockedAchievementIds();
    return current.contains(id);
  }
}

