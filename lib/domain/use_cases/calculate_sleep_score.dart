import '../entities/daily_log.dart';

enum SleepLevel {
  beginner('見習い', 0),
  novice('初心者', 7),
  practitioner('実践者', 21),
  expert('熟練者', 50),
  master('達人', 100),
  legend('伝説', 200);

  final String label;
  final int minStreak;
  const SleepLevel(this.label, this.minStreak);
}

class SleepScore {
  final int score; // 0–100
  final double routineRate;
  final double conditionRate;
  final SleepLevel level;
  final int streak;
  final int pointsToNextLevel;
  final SleepLevel? nextLevel;

  SleepScore({
    required this.score,
    required this.routineRate,
    required this.conditionRate,
    required this.level,
    required this.streak,
    required this.pointsToNextLevel,
    this.nextLevel,
  });
}

class CalculateSleepScore {
  SleepScore execute({
    required List<DailyLog> recentLogs,
    required int currentStreak,
  }) {
    if (recentLogs.isEmpty) {
      return SleepScore(
        score: 0,
        routineRate: 0,
        conditionRate: 0,
        level: SleepLevel.beginner,
        streak: 0,
        pointsToNextLevel: SleepLevel.novice.minStreak,
        nextLevel: SleepLevel.novice,
      );
    }

    // ルーティン達成率（60点満点）
    final completedDays =
        recentLogs.where((l) => l.eveningCompleted && l.morningCompleted).length;
    final routineRate = completedDays / recentLogs.length;
    final routineScore = (routineRate * 60).round();

    // コンディション（40点満点）: 眠気・イライラがない日を評価
    final goodConditionDays = recentLogs.where((l) {
      final hasData =
          l.daytimeSleepiness != null || l.feltIrritable != null;
      if (!hasData) return false; // 記録なし日はカウントしない
      final noSleepiness = l.daytimeSleepiness != true;
      final noIrritable = l.feltIrritable != true;
      return noSleepiness && noIrritable;
    }).length;
    final recordedDays =
        recentLogs.where((l) => l.daytimeSleepiness != null || l.feltIrritable != null).length;
    final conditionRate = recordedDays > 0 ? goodConditionDays / recordedDays : 0.5;
    final conditionScore = (conditionRate * 40).round();

    final totalScore = (routineScore + conditionScore).clamp(0, 100);

    // レベル計算
    final level = _calculateLevel(currentStreak);
    final nextLevel = _nextLevel(level);
    final pointsToNext =
        nextLevel != null ? nextLevel.minStreak - currentStreak : 0;

    return SleepScore(
      score: totalScore,
      routineRate: routineRate,
      conditionRate: conditionRate,
      level: level,
      streak: currentStreak,
      pointsToNextLevel: pointsToNext.clamp(0, 999),
      nextLevel: nextLevel,
    );
  }

  SleepLevel _calculateLevel(int streak) {
    final levels = SleepLevel.values.reversed.toList();
    for (final level in levels) {
      if (streak >= level.minStreak) return level;
    }
    return SleepLevel.beginner;
  }

  SleepLevel? _nextLevel(SleepLevel current) {
    final index = SleepLevel.values.indexOf(current);
    if (index < SleepLevel.values.length - 1) {
      return SleepLevel.values[index + 1];
    }
    return null;
  }
}
