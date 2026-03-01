abstract interface class AchievementRepository {
  Future<List<String>> getUnlockedAchievementIds();
  Future<void> unlockAchievement(String id);
  Future<bool> isUnlocked(String id);
}
