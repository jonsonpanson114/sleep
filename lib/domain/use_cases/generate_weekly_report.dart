import 'package:flutter/material.dart' show TimeOfDay;
import '../entities/weekly_report.dart';
import '../entities/daily_log.dart';
import 'calculate_streak.dart';

class GenerateWeeklyReport {
  final CalculateStreak _calculateStreak = CalculateStreak();

  WeeklyReport execute(
    List<DailyLog> weekLogs,
    List<DailyLog> previousWeekLogs,
  ) {
    final completionRate = _calculateStreak.completionRate(weekLogs);
    final previousRate = previousWeekLogs.isNotEmpty
        ? _calculateStreak.completionRate(previousWeekLogs)
        : null;

    final avgBedtime = _calculateAverageBedtime(weekLogs);
    final avgWakeTime = _calculateAverageWakeTime(weekLogs);
    final streak = _calculateStreak.current(weekLogs);
    final maxStreak = _calculateStreak.longest(weekLogs);

    final napDays = weekLogs.where((l) => l.napTaken == true).length;
    final sleepinessDays =
        weekLogs.where((l) => l.daytimeSleepiness == true).length;
    final irritableDays =
        weekLogs.where((l) => l.feltIrritable == true).length;

    // インサイトメッセージ生成
    final insightMessage = _generateInsightMessage(
      completionRate,
      previousRate,
      napDays,
      sleepinessDays,
      irritableDays,
      weekLogs.length,
    );

    return WeeklyReport(
      weekStart: weekLogs.last.date,
      weekEnd: weekLogs.first.date,
      completionRate: completionRate,
      previousWeekRate: previousRate,
      averageBedtime: avgBedtime,
      averageWakeTime: avgWakeTime,
      currentStreak: streak,
      maxStreak: maxStreak,
      napDays: napDays,
      sleepinessDays: sleepinessDays,
      irritableDays: irritableDays,
      insightMessage: insightMessage,
    );
  }

  TimeOfDay _calculateAverageBedtime(List<DailyLog> logs) {
    final completedLogs =
        logs.where((l) => l.eveningCompletedAt != null).toList();
    if (completedLogs.isEmpty) {
      return const TimeOfDay(hour: 22, minute: 30);
    }

    final totalMinutes = completedLogs.fold<int>(
      0,
      (sum, log) => sum + log.eveningCompletedAt!.hour * 60 + log.eveningCompletedAt!.minute,
    );

    final avgMinutes = totalMinutes ~/ completedLogs.length;
    return TimeOfDay(hour: avgMinutes ~/ 60, minute: avgMinutes % 60);
  }

  TimeOfDay _calculateAverageWakeTime(List<DailyLog> logs) {
    final completedLogs =
        logs.where((l) => l.morningCompletedAt != null).toList();
    if (completedLogs.isEmpty) {
      return const TimeOfDay(hour: 6, minute: 30);
    }

    final totalMinutes = completedLogs.fold<int>(
      0,
      (sum, log) => sum + log.morningCompletedAt!.hour * 60 + log.morningCompletedAt!.minute,
    );

    final avgMinutes = totalMinutes ~/ completedLogs.length;
    return TimeOfDay(hour: avgMinutes ~/ 60, minute: avgMinutes % 60);
  }

  String _generateInsightMessage(
    double rate,
    double? prevRate,
    int nap,
    int sleepiness,
    int irritable,
    int totalDays,
  ) {
    // 先週より改善
    if (prevRate != null && rate > prevRate! + 0.1) {
      final improvement = ((rate - prevRate!) * 100).toInt();
      return '先週より達成率が$improvement%向上しました！素晴らしい👍';
    }

    // 完璧な週
    if (irritable == 0 && sleepiness < 2 && rate > 0.9) {
      return 'イライラも眠気も少なく、充実した1週間でした！';
    }

    // 昼寝なし
    if (nap < 1 && totalDays >= 5) {
      return '昼寝せずに元気に過ごせましたね';
    }

    // デフォルトメッセージ
    if (rate < 0.6) {
      return '来週はもう少し就寝を早めに目指してみませんか？';
    }
    return '来週も頑張りましょう！';
  }
}
