import '../entities/routine_task.dart';

abstract interface class TaskRepository {
  Future<List<RoutineTask>> getAllTasks();
  Future<List<RoutineTask>> getTasksByType(RoutineType type);
  Future<void> addTask(RoutineTask task);
  Future<void> deleteTask(String id);
  Future<void> reorderTasks(List<RoutineTask> tasks);
}
