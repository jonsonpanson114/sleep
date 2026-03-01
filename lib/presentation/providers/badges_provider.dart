import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/achievement.dart';
import '../../core/achievements_data.dart';
import '../../domain/use_cases/check_achievements.dart';
import 'repository_providers.dart';
import 'streak_provider.dart';

final badgesProvider = FutureProvider<List<Achievement>>((ref) async {
  final logRepo = ref.watch(logRepositoryProvider);
  final achieveRepo = ref.watch(achievementRepositoryProvider);

  final allAchievements = AchievementsData.allAchievements;
  final unlockedIds = await achieveRepo.getUnlockedAchievementIds();

  final logs = await logRepo.getRecentLogs(90);
  final streak = await ref.read(streakProvider.future);

  final checker = CheckAchievements();
  return checker.execute(allAchievements, logs, streak, unlockedIds);
});

final unlockedAchievementsProvider =
    FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(achievementRepositoryProvider);
  return repo.getUnlockedAchievementIds();
});
