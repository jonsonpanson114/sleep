import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/routine_task.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/use_cases/complete_routine.dart';
import '../../domain/use_cases/toggle_task.dart';
import 'repository_providers.dart';

final routineTasksProvider =
    FutureProvider.autoDispose.family<List<RoutineTask>, RoutineType>(
        (ref, type) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksByType(type);
});

final todayLogProvider = StreamProvider<DailyLog?>((ref) {
  final repo = ref.watch(logRepositoryProvider);
  return repo.watchTodayLog();
});

final routineProvider =
    StateNotifierProvider<RoutineNotifier, RoutineState>((ref) {
  final taskRepo = ref.watch(taskRepositoryProvider);
  final logRepo = ref.watch(logRepositoryProvider);
  return RoutineNotifier(taskRepo, logRepo);
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
  final ToggleTask _toggleTask = ToggleTask();
  late final CompleteRoutine _completeRoutine;

  RoutineNotifier(this.taskRepo, this.logRepo)
      : super(const RoutineState(eveningTasks: [], morningTasks: [])) {
    _completeRoutine = CompleteRoutine(repo: logRepo);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final evening = await taskRepo.getTasksByType(RoutineType.evening);
    final morning = await taskRepo.getTasksByType(RoutineType.morning);
    state = RoutineState(eveningTasks: evening, morningTasks: morning);
  }

  Future<void> toggleTask(String taskId, DailyLog currentLog) async {
    final updatedLog = _toggleTask.execute(currentLog, taskId);
    await logRepo.saveLog(updatedLog);
  }

  Future<void> completeEveningRoutine(DailyLog log) async {
    if (log.eveningCompleted) return;
    await _completeRoutine.execute(RoutineType.evening, log);
  }

  Future<void> completeMorningRoutine(DailyLog log) async {
    if (log.morningCompleted) return;
    await _completeRoutine.execute(RoutineType.morning, log);
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
