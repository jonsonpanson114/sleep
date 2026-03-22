import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'data/repositories/settings_repository_impl.dart';
// import 'data/repositories/task_repository_impl.dart';
// import 'data/repositories/log_repository_impl.dart';
// import 'data/repositories/achievement_repository_impl.dart';
import 'data/repositories/web_mocks.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/repositories/task_repository.dart';
import 'domain/repositories/log_repository.dart';
import 'domain/repositories/achievement_repository.dart';
import 'data/services/notification_service.dart';
import 'presentation/providers/repository_providers.dart';
import 'app/theme.dart';
import 'app/router.dart';
// import 'data/database/app_database.dart';
import 'data/repositories/web_persistent.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  late SettingsRepository settingsRepo;
  late TaskRepository taskRepo;
  late LogRepository logRepo;
  late AchievementRepository achievementRepo;

  if (kIsWeb) {
    settingsRepo = WebSettingsPersistent();
    taskRepo = WebTaskPersistent();
    logRepo = WebLogPersistent();
    achievementRepo = WebAchievementPersistent();
  } else {
    // NOTE: Driftのコード生成エラー回避のため、Native環境でも一時的にMockを使用
    settingsRepo = WebSettingsMock();
    taskRepo = WebTaskMock();
    logRepo = WebLogMock();
    achievementRepo = WebAchievementMock();
  }

  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(settingsRepo),
        taskRepositoryProvider.overrideWithValue(taskRepo),
        logRepositoryProvider.overrideWithValue(logRepo),
        achievementRepositoryProvider.overrideWithValue(achievementRepo),
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
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: GoogleFonts.notoSansJpTextTheme(Theme.of(context).textTheme),
            ),
            child: child!,
          ),
        );
      },
    );
  }
}
