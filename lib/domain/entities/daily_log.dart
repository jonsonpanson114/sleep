class DailyLog {
  final DateTime date;
  final List<String> completedTaskIds;
  final bool eveningCompleted;
  final bool morningCompleted;
  final DateTime? eveningCompletedAt;
  final DateTime? morningCompletedAt;
  final bool? napTaken;
  final bool? daytimeSleepiness;
  final bool? feltIrritable;
  final String? dreamNote;
  final DateTime? bedTime;
  final DateTime? wakeTime;
  final int? sleepDurationMinutes;

  const DailyLog({
    required this.date,
    this.completedTaskIds = const [],
    this.eveningCompleted = false,
    this.morningCompleted = false,
    this.eveningCompletedAt,
    this.morningCompletedAt,
    this.napTaken,
     this.daytimeSleepiness,
    this.feltIrritable,
    this.dreamNote,
    this.bedTime,
    this.wakeTime,
    this.sleepDurationMinutes,
  });

  DailyLog copyWith({
    DateTime? date,
    List<String>? completedTaskIds,
    bool? eveningCompleted,
    bool? morningCompleted,
    DateTime? eveningCompletedAt,
    DateTime? morningCompletedAt,
    bool? napTaken,
     bool? daytimeSleepiness,
    bool? feltIrritable,
    String? dreamNote,
    DateTime? bedTime,
    DateTime? wakeTime,
    int? sleepDurationMinutes,
  }) {
    return DailyLog(
      date: date ?? this.date,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds,
      eveningCompleted: eveningCompleted ?? this.eveningCompleted,
      morningCompleted: morningCompleted ?? this.morningCompleted,
      eveningCompletedAt: eveningCompletedAt ?? this.eveningCompletedAt,
      morningCompletedAt: morningCompletedAt ?? this.morningCompletedAt,
      napTaken: napTaken ?? this.napTaken,
       daytimeSleepiness: daytimeSleepiness ?? this.daytimeSleepiness,
      feltIrritable: feltIrritable ?? this.feltIrritable,
      dreamNote: dreamNote ?? this.dreamNote,
      bedTime: bedTime ?? this.bedTime,
      wakeTime: wakeTime ?? this.wakeTime,
      sleepDurationMinutes: sleepDurationMinutes ?? this.sleepDurationMinutes,
    );
  }
}
