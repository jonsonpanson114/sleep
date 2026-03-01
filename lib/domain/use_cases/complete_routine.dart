import '../entities/daily_log.dart';
import '../repositories/log_repository.dart';
import '../entities/routine_task.dart';

class CompleteRoutine {
  final LogRepository repo;

  CompleteRoutine({required this.repo});

  /// ルーティンを完了としてマーク
  Future<void> execute(RoutineType type, DailyLog log) async {
    final updatedLog = type == RoutineType.evening
        ? log.copyWith(
            eveningCompleted: true,
            eveningCompletedAt: DateTime.now(),
          )
        : log.copyWith(
            morningCompleted: true,
            morningCompletedAt: DateTime.now(),
          );

    await repo.saveLog(updatedLog);
  }
}
