import '../domain/entities/achievement.dart';
import 'constants.dart';

/// 全バッジ定義
class AchievementsData {
  static const allAchievements = <Achievement>[
    Achievement(
      id: AchievementIds.firstComplete,
      title: 'はじめの一歩',
      description: '初めて両ルーティンを完了しました',
      emoji: '🌱',
      condition: AchievementCondition(
        type: ConditionType.allCompletedDays,
        threshold: 1,
      ),
      goal: 1,
    ),
    Achievement(
      id: AchievementIds.streak7,
      title: '一週間の炎',
      description: '7日連続で達成しました',
      emoji: '🔥',
      condition: AchievementCondition(
        type: ConditionType.streak,
        threshold: 7,
      ),
      goal: 7,
    ),
    Achievement(
      id: AchievementIds.streak30,
      title: '満月マスター',
      description: '30日連続で達成しました',
      emoji: '🌕',
      condition: AchievementCondition(
        type: ConditionType.streak,
        threshold: 30,
      ),
      goal: 30,
    ),
    Achievement(
      id: AchievementIds.streak100,
      title: '睡眠王',
      description: '100日連続で達成しました',
      emoji: '👑',
      condition: AchievementCondition(
        type: ConditionType.streak,
        threshold: 100,
      ),
      goal: 100,
    ),
    Achievement(
      id: AchievementIds.noSleepiness7,
      title: 'エネルギッシュ',
      description: '日中の眠気ゼロが7日続き',
      emoji: '⚡',
      condition: AchievementCondition(
        type: ConditionType.noSleepinessDays,
        threshold: 7,
      ),
      goal: 7,
    ),
    Achievement(
      id: AchievementIds.earlyBed7,
      title: '早起き鳥',
      description: '22:30以前に就寝が7日',
      emoji: '🐦',
      condition: AchievementCondition(
        type: ConditionType.earlyBedtimeDays,
        threshold: 7,
      ),
      goal: 7,
    ),
    Achievement(
      id: AchievementIds.perfectWeek4,
      title: '完璧な4週間',
      description: '4週間100%達成',
      emoji: '✨',
      condition: AchievementCondition(
        type: ConditionType.allCompletedDays,
        threshold: 28,
      ),
      goal: 28,
    ),
  ];
}
