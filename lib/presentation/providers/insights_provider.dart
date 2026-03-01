import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/calculate_correlation.dart';
import '../../domain/entities/weekly_summary.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/use_cases/calculate_weekly_pattern.dart';
import '../../domain/use_cases/calculate_sleep_analytics.dart';
import '../../data/services/weekly_summary_specialist.dart';
import 'repository_providers.dart';
import 'analytics_provider.dart';

class InsightsData {
  final List<CorrelationInsight> insights;
  final WeeklySummary weeklySummary;
  final List<DailyLog> logs;
  final WeeklyPatternResult weeklyPattern;
  final SleepAnalyticsResult analytics;

  InsightsData({
    required this.insights,
    required this.weeklySummary,
    required this.logs,
    required this.weeklyPattern,
    required this.analytics,
  });
}

final insightsProvider = FutureProvider<InsightsData>((ref) async {
  final repo = ref.watch(logRepositoryProvider);
  final logs = await repo.getRecentLogs(90);

  final calculator = CalculateCorrelation();
  final insights = calculator.execute(logs);

  final weeklySummary = WeeklySummarySpecialist.generate(logs);

  final patternCalc = CalculateWeeklyPattern();
  final weeklyPattern = patternCalc.execute(logs);
  
  final analytics = await ref.watch(sleepAnalyticsProvider.future);

  return InsightsData(
    insights: insights,
    weeklySummary: weeklySummary,
    logs: logs,
    weeklyPattern: weeklyPattern,
    analytics: analytics,
  );
});
