import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/calculate_streak.dart';
import '../../domain/use_cases/calculate_sleep_score.dart';
import 'repository_providers.dart';

final streakProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(logRepositoryProvider);
  final logs = await repo.getRecentLogs(90);
  final calculator = CalculateStreak();
  return calculator.current(logs);
});

final longestStreakProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(logRepositoryProvider);
  final logs = await repo.getRecentLogs(90);
  final calculator = CalculateStreak();
  return calculator.longest(logs);
});

final sleepScoreProvider = FutureProvider<SleepScore>((ref) async {
  final repo = ref.watch(logRepositoryProvider);
  final logs = await repo.getRecentLogs(30);
  final streak = await ref.watch(streakProvider.future);
  final calculator = CalculateSleepScore();
  return calculator.execute(
    recentLogs: logs,
    currentStreak: streak,
  );
});
