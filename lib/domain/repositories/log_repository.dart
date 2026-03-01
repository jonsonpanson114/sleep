import '../entities/daily_log.dart';

abstract interface class LogRepository {
  Future<DailyLog?> getLog(String dateKey);
  Future<DailyLog?> getTodayLog();
  Future<void> saveLog(DailyLog log);
  Future<List<DailyLog>> getRecentLogs(int days);
  Future<List<DailyLog>> getLogsInRange(DateTime start, DateTime end);
  Stream<DailyLog?> watchTodayLog();
}
