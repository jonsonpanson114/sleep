enum ConditionType {
  streak,
  noSleepinessDays,
  allCompletedDays,
  earlyBedtimeDays,
}

class AchievementCondition {
  final ConditionType type;
  final int threshold;

  const AchievementCondition({
    required this.type,
    this.threshold = 0,
  });
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final AchievementCondition condition;
  final int progress;
  final int goal;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.condition,
    this.progress = 0,
    this.goal = 0,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    AchievementCondition? condition,
    int? progress,
    int? goal,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      condition: condition ?? this.condition,
      progress: progress ?? this.progress,
      goal: goal ?? this.goal,
    );
  }
}
