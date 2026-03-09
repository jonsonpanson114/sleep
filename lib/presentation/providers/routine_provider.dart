import 'dart:convert';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/routine_task.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/use_cases/complete_routine.dart';
import '../../domain/use_cases/toggle_task.dart';
import '../../data/repositories/web_persistent.dart';
import 'repository_providers.dart';

final routineTasksProvider =
    StreamProvider.autoDispose.family<List<RoutineTask>, RoutineType>(
        (ref, type) {
  final repo = ref.watch(taskRepositoryProvider);
  
  if (repo is WebTaskPersistent) {
    return repo.watchTasksByType(type);
  }
  
  // fallback for native (simple Future to Stream conversion)
  return Stream.fromFuture(repo.getTasksByType(type));
});

final todayLogProvider = StreamProvider<DailyLog?>((ref) {
  final repo = ref.watch(logRepositoryProvider);
  return repo.watchTodayLog();
});

final routineProvider =
    StateNotifierProvider<RoutineNotifier, RoutineState>((ref) {
  final taskRepo = ref.watch(taskRepositoryProvider);
  final logRepo = ref.watch(logRepositoryProvider);
  return RoutineNotifier(taskRepo, logRepo, ref);
});

class RoutineState {
  final List<RoutineTask> eveningTasks;
  final List<RoutineTask> morningTasks;

  const RoutineState({
    required this.eveningTasks,
    required this.morningTasks,
  });
}

class RoutineNotifier extends StateNotifier<RoutineState> {
  final TaskRepository taskRepo;
  final LogRepository logRepo;
  final Ref ref;
  final ToggleTask _toggleTask = ToggleTask();
  late final CompleteRoutine _completeRoutine;

  RoutineNotifier(this.taskRepo, this.logRepo, this.ref)
      : super(const RoutineState(eveningTasks: [], morningTasks: [])) {
    _completeRoutine = CompleteRoutine(repo: logRepo);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final evening = await taskRepo.getTasksByType(RoutineType.evening);
    final morning = await taskRepo.getTasksByType(RoutineType.morning);
    state = RoutineState(eveningTasks: evening, morningTasks: morning);
  }
  Future<void> toggleTask(String taskId) async {
    final currentLog = await logRepo.getTodayLog();
    final log = currentLog ??
        DailyLog(
          date: DateTime.now(),
          completedTaskIds: const [],
          eveningCompleted: false,
          morningCompleted: false,
        );
    final updatedLog = _toggleTask.execute(log, taskId);
    await logRepo.saveLog(updatedLog);
    ref.invalidate(todayLogProvider);
  }

  Future<void> completeEveningRoutine(DailyLog log) async {
    final latestLog = await logRepo.getTodayLog() ?? log;
    if (latestLog.eveningCompleted) return;
    final snapshot = _buildSnapshot(state.eveningTasks, latestLog);
    final updatedLog = latestLog.copyWith(eveningTaskSnapshot: snapshot);
    await _completeRoutine.execute(RoutineType.evening, updatedLog);
    ref.invalidate(todayLogProvider);
  }

  Future<void> completeMorningRoutine(DailyLog log) async {
    final latestLog = await logRepo.getTodayLog() ?? log;
    if (latestLog.morningCompleted) return;
    final snapshot = _buildSnapshot(state.morningTasks, latestLog);
    final updatedLog = latestLog.copyWith(morningTaskSnapshot: snapshot);
    await _completeRoutine.execute(RoutineType.morning, updatedLog);
    ref.invalidate(todayLogProvider);
  }

  Future<void> completeMorningRoutineWithSleep(
    DailyLog log,
    DateTime bedTime,
    DateTime wakeTime,
    TimeOfDay? idealBedTime,
    TimeOfDay? idealWakeTime,
  ) async {
    if (log.morningCompleted) return;

    // 睡眠時間を計算
    final duration = wakeTime.difference(bedTime);
    final sleepDurationMinutes = duration.inMinutes;

    final snapshot = _buildSnapshot(state.morningTasks, log);

    // 睡眠時間を含めてログを更新
    final updatedLog = log.copyWith(
      bedTime: bedTime,
      wakeTime: wakeTime,
      sleepDurationMinutes: sleepDurationMinutes,
      morningTaskSnapshot: snapshot,
      idealBedTime: idealBedTime,
      idealWakeTime: idealWakeTime,
    );

    // ルーティンを完了
    await _completeRoutine.execute(RoutineType.morning, updatedLog);
    ref.invalidate(todayLogProvider);
  }

  Future<void> updateSleepTime({
    required DailyLog log,
    required DateTime bedTime,
    required DateTime wakeTime,
    TimeOfDay? idealBedTime,
    TimeOfDay? idealWakeTime,
  }) async {
    // 睡眠時間を計算
    // wakeTime が bedTime より前の場合（日付跨ぎ）、wakeTime を翌日として扱う
    var adjustedWakeTime = wakeTime;
    var adjustedBedTime = bedTime;
    
    final rawDuration = wakeTime.difference(bedTime);
    
    // もし差分が24時間以上ある場合、UI/データの保存ミスで日付が1日ズレている可能性が高いため補正
    if (rawDuration.inHours >= 24) {
      adjustedBedTime = bedTime.add(const Duration(days: 1));
    } else if (rawDuration.isNegative) {
      // 逆にマイナスの場合は起床が翌日（日付を跨いでいる）
      adjustedWakeTime = wakeTime.add(const Duration(days: 1));
    }
    
    final duration = adjustedWakeTime.difference(adjustedBedTime);
    final sleepDurationMinutes = duration.inMinutes;

    // 睡眠時間データのみを更新（ルーティン完了フラグは触らない）
    final updatedLog = log.copyWith(
      bedTime: bedTime,
      wakeTime: wakeTime,
      sleepDurationMinutes: sleepDurationMinutes,
      idealBedTime: idealBedTime,
      idealWakeTime: idealWakeTime,
    );

    await logRepo.saveLog(updatedLog);
    ref.invalidate(todayLogProvider);
  }

  String _buildSnapshot(List<RoutineTask> tasks, DailyLog log) {
    final list = tasks.map((t) => {
      'title': t.title,
      'completed': log.completedTaskIds.contains(t.id),
    }).toList();
    return jsonEncode(list);
  }

  Future<void> addTask(RoutineTask task) async {
    await taskRepo.addTask(task);
    await _loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await taskRepo.deleteTask(id);
    await _loadTasks();
  }

  Future<void> reorderTasks(RoutineType type, List<RoutineTask> tasks) async {
    await taskRepo.reorderTasks(tasks);
    await _loadTasks();
  }
}
