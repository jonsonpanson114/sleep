import '../entities/daily_log.dart';

class DayOfWeekStats {
  final String label;
  final int weekday; // 1=月 ... 7=日
  final double completionRate;
  final bool isWeekend;

  DayOfWeekStats({
    required this.label,
    required this.weekday,
    required this.completionRate,
    required this.isWeekend,
  });
}

class WeeklyPatternResult {
  final List<DayOfWeekStats> byDayOfWeek;
  final double weekdayAvg;
  final double weekendAvg;
  final String? bestDay;
  final String? worstDay;

  WeeklyPatternResult({
    required this.byDayOfWeek,
    required this.weekdayAvg,
    required this.weekendAvg,
    this.bestDay,
    this.worstDay,
  });
}

class CalculateWeeklyPattern {
  static const _dayLabels = ['月', '火', '水', '木', '金', '土', '日'];

  WeeklyPatternResult execute(List<DailyLog> logs) {
    if (logs.isEmpty) {
      return WeeklyPatternResult(
        byDayOfWeek: List.generate(
          7,
          (i) => DayOfWeekStats(
            label: _dayLabels[i],
            weekday: i + 1,
            completionRate: 0,
            isWeekend: i >= 5,
          ),
        ),
        weekdayAvg: 0,
        weekendAvg: 0,
      );
    }

    // 曜日ごとにグループ化
    final Map<int, List<DailyLog>> byWeekday = {};
    for (var log in logs) {
      final wd = log.date.weekday; // 1=月...7=日
      byWeekday.putIfAbsent(wd, () => []).add(log);
    }

    final stats = <DayOfWeekStats>[];
    for (int i = 0; i < 7; i++) {
      final wd = i + 1;
      final dayLogs = byWeekday[wd] ?? [];
      final rate = dayLogs.isEmpty
          ? 0.0
          : dayLogs.where((l) => l.eveningCompleted && l.morningCompleted).length /
              dayLogs.length;
      stats.add(DayOfWeekStats(
        label: _dayLabels[i],
        weekday: wd,
        completionRate: rate,
        isWeekend: wd >= 6,
      ));
    }

    // 平日 / 週末の平均
    final weekdayStats = stats.where((s) => !s.isWeekend).toList();
    final weekendStats = stats.where((s) => s.isWeekend).toList();

    final weekdayAvg = weekdayStats.isEmpty
        ? 0.0
        : weekdayStats.map((s) => s.completionRate).reduce((a, b) => a + b) /
            weekdayStats.length;
    final weekendAvg = weekendStats.isEmpty
        ? 0.0
        : weekendStats.map((s) => s.completionRate).reduce((a, b) => a + b) /
            weekendStats.length;

    // ベスト/ワースト曜日（データのある日だけ）
    final nonZero = stats.where((s) {
      final dayLogs = byWeekday[s.weekday] ?? [];
      return dayLogs.isNotEmpty;
    }).toList();

    String? bestDay;
    String? worstDay;
    if (nonZero.isNotEmpty) {
      nonZero.sort((a, b) => b.completionRate.compareTo(a.completionRate));
      bestDay = nonZero.first.label;
      worstDay = nonZero.last.label;
    }

    return WeeklyPatternResult(
      byDayOfWeek: stats,
      weekdayAvg: weekdayAvg,
      weekendAvg: weekendAvg,
      bestDay: bestDay,
      worstDay: worstDay,
    );
  }
}
