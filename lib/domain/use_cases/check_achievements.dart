import '../entities/achievement.dart';
import '../entities/daily_log.dart';
import '../../core/date_utils.dart';

class CheckAchievements {
  List<Achievement> execute(
    List<Achievement> allAchievements,
    List<DailyLog> logs,
    int currentStreak,
    List<String> unlockedIds,
  ) {
    final newAchievements = <Achievement>[];

    for (final achievement in allAchievements) {
      if (unlockedIds.contains(achievement.id)) continue;

      final condition = achievement.condition;
      int progress = 0;
      bool achieved = false;

      switch (condition.type) {
        case ConditionType.streak:
          progress = currentStreak;
          achieved = currentStreak >= condition.threshold;
          break;

        case ConditionType.noSleepinessDays:
          progress = logs
              .where((l) => l.daytimeSleepiness == false)
              .length;
          achieved = progress >= condition.threshold;
          break;

        case ConditionType.allCompletedDays:
          progress = logs
              .where((l) => l.eveningCompleted && l.morningCompleted)
              .length;
          achieved = progress >= condition.threshold;
          break;

        case ConditionType.earlyBedtimeDays:
          progress = logs.where((l) => DateUtils.isEarlyBedtime(l.date)).length;
          achieved = progress >= condition.threshold;
          break;
      }

      if (achieved) {
        newAchievements.add(achievement.copyWith(progress: progress));
      }
    }

    return newAchievements;
  }
}
