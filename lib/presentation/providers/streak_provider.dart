import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/calculate_streak.dart';
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
