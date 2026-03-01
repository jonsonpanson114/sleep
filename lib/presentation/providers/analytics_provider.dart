import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/daily_advice_specialist.dart';
import '../../domain/use_cases/calculate_sleep_analytics.dart';
import '../providers/repository_providers.dart';
import '../providers/settings_provider.dart';

final dailyAdviceProvider = Provider<DailyAdvice>((ref) {
  return DailyAdviceSpecialist.getAdvice();
});

final sleepAnalyticsProvider = FutureProvider<SleepAnalyticsResult>((ref) async {
  final repo = ref.watch(logRepositoryProvider);
  final settingsAsync = ref.watch(settingsProvider);
  
  if (settingsAsync.value == null) {
    return SleepAnalyticsResult(
      fatigueLevel: 0,
      suggestEarlySleep: false,
      insightMessage: '設定を読み込んでいます...',
    );
  }

  // 直近14日間のログで分析する
  final logs = await repo.getRecentLogs(14);
  final calculator = CalculateSleepAnalytics();
  return calculator.execute(
    logs: logs,
    currentSettings: settingsAsync.value!,
  );
});
