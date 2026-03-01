import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/repositories/log_repository.dart';
import '../../core/date_utils.dart';
import '../database/app_database.dart';

class LogRepositoryImpl implements LogRepository {
  final AppDatabase db;

  LogRepositoryImpl() : db = AppDatabase();

  @override
  Future<DailyLog?> getLog(String dateKey) async {
    final log = await (db.select(db.logsTable)
          ..where((l) => l.dateKey.equals(dateKey)))
        .getSingleOrNull();
    return log != null ? _toEntity(log) : null;
  }

  @override
  Future<DailyLog?> getTodayLog() async {
    final todayKey = DateUtils.todayKey;
    final log = await (db.select(db.logsTable)
          ..where((l) => l.dateKey.equals(todayKey)))
        .getSingleOrNull();
    return log != null ? _toEntity(log) : null;
  }

  @override
  Future<void> saveLog(DailyLog log) async {
    final existing = await getTodayLog();

    if (existing == null) {
      await db.into(db.logsTable).insert(LogsTableCompanion.insert(
            dateKey: DateUtils.todayKey,
            completedTaskIds: jsonEncode(log.completedTaskIds),
            eveningCompleted: Value(log.eveningCompleted),
            morningCompleted: Value(log.morningCompleted),
            eveningCompletedAt: Value(log.eveningCompletedAt),
            morningCompletedAt: Value(log.morningCompletedAt),
            napTaken: Value(log.napTaken),
            daytimeSleepiness: Value(log.daytimeSleepiness),
            feltIrritable: Value(log.feltIrritable),
          ));
    } else {
      await (db.update(db.logsTable)
            ..where((l) => l.dateKey.equals(DateUtils.todayKey)))
          .write(LogsTableCompanion(
        completedTaskIds: Value(jsonEncode(log.completedTaskIds)),
        eveningCompleted: Value(log.eveningCompleted),
        morningCompleted: Value(log.morningCompleted),
        eveningCompletedAt: Value(log.eveningCompletedAt),
        morningCompletedAt: Value(log.morningCompletedAt),
        napTaken: Value(log.napTaken),
        daytimeSleepiness: Value(log.daytimeSleepiness),
        feltIrritable: Value(log.feltIrritable),
      ));
    }
  }

  @override
  Future<List<DailyLog>> getRecentLogs(int days) async {
    final logs = await (db.select(db.logsTable)
          ..orderBy([(l) => OrderingTerm.desc(l.dateKey)])
          ..limit(days))
        .get();
    return logs.map<DailyLog>(_toEntity).toList();
  }

  @override
  Future<List<DailyLog>> getLogsInRange(DateTime start, DateTime end) async {
    final startKey = DateFormat('yyyy-MM-dd').format(start);
    final endKey = DateFormat('yyyy-MM-dd').format(end);

    final logs = await (db.select(db.logsTable)
          ..where((l) =>
              l.dateKey.isBiggerOrEqualValue(startKey) &
              l.dateKey.isSmallerOrEqualValue(endKey))
          ..orderBy([(l) => OrderingTerm.desc(l.dateKey)]))
        .get();
    return logs.map<DailyLog>(_toEntity).toList();
  }

  @override
  Stream<DailyLog?> watchTodayLog() {
    return (db.select(db.logsTable)
          ..where((l) => l.dateKey.equals(DateUtils.todayKey)))
        .watchSingleOrNull()
        .map((data) => data != null ? _toEntity(data) : null);
  }

  DailyLog _toEntity(Log log) {
    final taskIds = log.completedTaskIds.isEmpty
        ? <String>[]
        : (jsonDecode(log.completedTaskIds) as List).cast<String>();
    return DailyLog(
      date: log.eveningCompletedAt ?? log.morningCompletedAt ?? DateTime.now(),
      completedTaskIds: taskIds,
      eveningCompleted: log.eveningCompleted,
      morningCompleted: log.morningCompleted,
      eveningCompletedAt: log.eveningCompletedAt,
      morningCompletedAt: log.morningCompletedAt,
      napTaken: log.napTaken,
      daytimeSleepiness: log.daytimeSleepiness,
      feltIrritable: log.feltIrritable,
    );
  }
}
