import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/repositories/achievement_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError('SettingsRepository must be overridden');
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  throw UnimplementedError('TaskRepository must be overridden');
});

final logRepositoryProvider = Provider<LogRepository>((ref) {
  throw UnimplementedError('LogRepository must be overridden');
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  throw UnimplementedError('AchievementRepository must be overridden');
});
