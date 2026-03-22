import 'package:drift/drift.dart';
import '../../domain/entities/routine_task.dart';
import '../../domain/repositories/task_repository.dart';
import '../database/app_database.dart';

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase db;

  TaskRepositoryImpl(this.db);

  @override
  Future<List<RoutineTask>> getAllTasks() async {
    final tasks = await db.select(db.tasksTable).get();
    return tasks
        .map((t) => RoutineTask(
              id: t.id,
              title: t.title,
              type: t.routineType == 'evening'
                  ? RoutineType.evening
                  : RoutineType.morning,
              sortOrder: t.sortOrder,
              startTime: t.startTime,
              endTime: t.endTime,
            ))
        .toList();
  }

  @override
  Future<List<RoutineTask>> getTasksByType(RoutineType type) async {
    final typeStr = type == RoutineType.evening ? 'evening' : 'morning';
    final tasks = await (db.select(db.tasksTable)
          ..where((t) => t.routineType.equals(typeStr))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return tasks
        .map((t) => RoutineTask(
              id: t.id,
              title: t.title,
              type: type,
              sortOrder: t.sortOrder,
              startTime: t.startTime,
              endTime: t.endTime,
            ))
        .toList();
  }

  @override
  Future<void> addTask(RoutineTask task) async {
    await db.into(db.tasksTable).insert(TasksTableCompanion.insert(
          id: task.id,
          title: task.title,
          routineType: task.type == RoutineType.evening ? 'evening' : 'morning',
          sortOrder: task.sortOrder,
          startTime: Value(task.startTime),
          endTime: Value(task.endTime),
        ));
  }

  @override
  Future<void> deleteTask(String id) async {
    await (db.delete(db.tasksTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> reorderTasks(List<RoutineTask> tasks) async {
    await db.transaction(() async {
      for (var i = 0; i < tasks.length; i++) {
        await (db.update(db.tasksTable)
              ..where((t) => t.id.equals(tasks[i].id)))
            .write(TasksTableCompanion(sortOrder: Value(i)));
      }
    });
  }

  @override
  Future<void> updateTask(RoutineTask task) async {
    await (db.update(db.tasksTable)..where((t) => t.id.equals(task.id)))
        .write(TasksTableCompanion(
      title: Value(task.title),
      startTime: Value(task.startTime),
      endTime: Value(task.endTime),
    ));
  }
}
