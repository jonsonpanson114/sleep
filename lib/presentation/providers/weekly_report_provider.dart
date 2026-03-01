import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/weekly_report.dart';
import '../../domain/use_cases/generate_weekly_report.dart';
import '../../core/date_utils.dart';
import 'repository_providers.dart';

final weeklyReportProvider = FutureProvider<WeeklyReport?>((ref) async {
  final repo = ref.watch(logRepositoryProvider);
  final now = DateTime.now();
  final startOfWeek = DateUtils.startOfWeek(now);

  // 今週のログを取得
  final weekLogs = await repo.getLogsInRange(
        startOfWeek.subtract(const Duration(days: 7)),
        startOfWeek.add(const Duration(days: 6)),
      );

  // 先週のログを取得
  final previousWeekLogs = await repo.getLogsInRange(
        startOfWeek.subtract(const Duration(days: 14)),
        startOfWeek.subtract(const Duration(days: 1)),
      );

  if (weekLogs.isEmpty) return null;

  final generator = GenerateWeeklyReport();
  return generator.execute(weekLogs, previousWeekLogs);
});
