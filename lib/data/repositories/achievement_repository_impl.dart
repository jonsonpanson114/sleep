import 'package:drift/drift.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../database/app_database.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final AppDatabase db;

  AchievementRepositoryImpl(this.db);

  @override
  Future<List<String>> getUnlockedAchievementIds() async {
    final achievements = await (db.select(db.achievementsTable)).get();
    return achievements.map((a) => a.id).toList();
  }

  @override
  Future<void> unlockAchievement(String id) async {
    final existing = await (db.select(db.achievementsTable)
          ..where((a) => a.id.equals(id)))
        .getSingleOrNull();

    if (existing == null) {
      await db.into(db.achievementsTable).insert(
            AchievementsTableCompanion.insert(
              id: id,
              unlockedAt: DateTime.now(),
            ),
          );
    }
  }

  @override
  Future<bool> isUnlocked(String id) async {
    final existing = await (db.select(db.achievementsTable)
          ..where((a) => a.id.equals(id)))
        .getSingleOrNull();
    return existing != null;
  }
}
