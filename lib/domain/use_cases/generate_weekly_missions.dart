import '../entities/daily_log.dart';

enum MissionDifficulty { easy, medium, hard }

class WeeklyMission {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final MissionDifficulty difficulty;
  final int targetDays; // 達成に必要な日数
  final int currentDays; // 現在の進捗日数
  final bool isCompleted;

  WeeklyMission({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.difficulty,
    required this.targetDays,
    required this.currentDays,
    required this.isCompleted,
  });

  double get progress => targetDays > 0 ? (currentDays / targetDays).clamp(0.0, 1.0) : 0;
}

class GenerateWeeklyMissions {
  /// 今週のログから、適切なミッションを生成して進捗を算出する
  List<WeeklyMission> execute(List<DailyLog> weekLogs) {
    final missions = _allMissions();
    return missions.map((m) => _evaluateMission(m, weekLogs)).toList();
  }

  WeeklyMission _evaluateMission(WeeklyMission template, List<DailyLog> logs) {
    int progress = 0;

    switch (template.id) {
      case 'both_complete_5':
        // 5日間両方のルーティンを完了
        progress = logs.where((l) => l.eveningCompleted && l.morningCompleted).length;
        break;
      case 'no_sleepiness_3':
        // 3日間昼間の眠気なし
        progress = logs
            .where((l) => l.daytimeSleepiness == false)
            .length;
        break;
      case 'evening_complete_7':
        // 7日間夜ルーティン完了
        progress = logs.where((l) => l.eveningCompleted).length;
        break;
      case 'morning_complete_5':
        // 5日間朝ルーティン完了
        progress = logs.where((l) => l.morningCompleted).length;
        break;
      case 'no_nap_5':
        // 5日間昼寝なし
        progress = logs.where((l) => l.napTaken == false).length;
        break;
      case 'no_irritable_3':
        // 3日間イライラなし
        progress = logs
            .where((l) => l.feltIrritable == false)
            .length;
        break;
    }

    final clamped = progress.clamp(0, template.targetDays);
    return WeeklyMission(
      id: template.id,
      title: template.title,
      description: template.description,
      emoji: template.emoji,
      difficulty: template.difficulty,
      targetDays: template.targetDays,
      currentDays: clamped,
      isCompleted: clamped >= template.targetDays,
    );
  }

  List<WeeklyMission> _allMissions() => [
    WeeklyMission(
      id: 'evening_complete_7',
      title: '夜番人',
      description: '今週7日間、夜のルーティンを完了させろ',
      emoji: '🌙',
      difficulty: MissionDifficulty.hard,
      targetDays: 7,
      currentDays: 0,
      isCompleted: false,
    ),
    WeeklyMission(
      id: 'morning_complete_5',
      title: '朝の戦士',
      description: '今週5日間、朝のルーティンを完了させろ',
      emoji: '☀️',
      difficulty: MissionDifficulty.medium,
      targetDays: 5,
      currentDays: 0,
      isCompleted: false,
    ),
    WeeklyMission(
      id: 'both_complete_5',
      title: '完全制覇',
      description: '今週5日、両ルーティンを完了させろ',
      emoji: '👑',
      difficulty: MissionDifficulty.hard,
      targetDays: 5,
      currentDays: 0,
      isCompleted: false,
    ),
    WeeklyMission(
      id: 'no_sleepiness_3',
      title: '目覚めの門番',
      description: '3日間、昼間に眠くならずに過ごせ',
      emoji: '👁️',
      difficulty: MissionDifficulty.medium,
      targetDays: 3,
      currentDays: 0,
      isCompleted: false,
    ),
    WeeklyMission(
      id: 'no_nap_5',
      title: '昼寝断ち',
      description: '5日間、昼寝をしないで夜まで持たせろ',
      emoji: '🚫',
      difficulty: MissionDifficulty.easy,
      targetDays: 5,
      currentDays: 0,
      isCompleted: false,
    ),
    WeeklyMission(
      id: 'no_irritable_3',
      title: '平常心',
      description: '3日間、イライラせずに過ごせ',
      emoji: '😌',
      difficulty: MissionDifficulty.easy,
      targetDays: 3,
      currentDays: 0,
      isCompleted: false,
    ),
  ];
}
