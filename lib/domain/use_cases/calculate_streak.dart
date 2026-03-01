import '../entities/daily_log.dart';
import '../../core/date_utils.dart';

class CalculateStreak {
  /// 両ルーティン完了の日を「達成日」として連続日数を計算
  int current(List<DailyLog> logs) {
    if (logs.isEmpty) return 0;

    // 日付でソート
    final sortedLogs = List<DailyLog>.from(logs)
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;

    for (final log in sortedLogs) {
      // 両ルーティン完了の日だけをカウント
      if (log.eveningCompleted && log.morningCompleted) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  /// 過去最高の連続達成日数を計算
  int longest(List<DailyLog> logs) {
    if (logs.isEmpty) return 0;

    final sortedLogs = List<DailyLog>.from(logs)
      ..sort((a, b) => b.date.compareTo(a.date));

    int maxStreak = 0;
    int currentStreak = 0;

    for (final log in sortedLogs) {
      if (log.eveningCompleted && log.morningCompleted) {
        currentStreak++;
        if (currentStreak > maxStreak) {
          maxStreak = currentStreak;
        }
      } else {
        currentStreak = 0;
      }
    }

    return maxStreak;
  }

  /// 達成率を計算（0.0 ~ 1.0）
  double completionRate(List<DailyLog> logs) {
    if (logs.isEmpty) return 0.0;

    final completedDays = logs
        .where((log) => log.eveningCompleted && log.morningCompleted)
        .length;

    return completedDays / logs.length;
  }
}
