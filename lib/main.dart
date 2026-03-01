import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'data/repositories/task_repository_impl.dart';
import 'data/repositories/log_repository_impl.dart';
import 'data/repositories/achievement_repository_impl.dart';
import 'data/services/notification_service.dart';
import 'presentation/providers/repository_providers.dart';
import 'app/theme.dart';
import 'app/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(SettingsRepositoryImpl()),
        taskRepositoryProvider.overrideWithValue(TaskRepositoryImpl()),
        logRepositoryProvider.overrideWithValue(LogRepositoryImpl()),
        achievementRepositoryProvider.overrideWithValue(AchievementRepositoryImpl()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: '睡眠ルーティン',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
