import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/generate_weekly_missions.dart';
import 'repository_providers.dart';

final weeklyMissionsProvider = FutureProvider<List<WeeklyMission>>((ref) async {
  final repo = ref.watch(logRepositoryProvider);
  // 今週のログを取得（7日分）
  final logs = await repo.getRecentLogs(7);
  final generator = GenerateWeeklyMissions();
  return generator.execute(logs);
});
