import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/calculate_correlation.dart';
import '../../domain/entities/weekly_summary.dart';
import '../../domain/entities/daily_log.dart';
import '../../data/services/weekly_summary_specialist.dart';
import 'repository_providers.dart';

class InsightsData {
  final List<CorrelationInsight> insights;
  final WeeklySummary weeklySummary;
  final List<DailyLog> logs;

  InsightsData({
    required this.insights,
    required this.weeklySummary,
    required this.logs,
  });
}

final insightsProvider = FutureProvider<InsightsData>((ref) async {
  final repo = ref.watch(logRepositoryProvider);
  // Get more logs to have a better summary, e.g., last 7 days
  final logs = await repo.getRecentLogs(30); 
  
  final calculator = CalculateCorrelation();
  final insights = calculator.execute(logs);
  
  final weeklySummary = WeeklySummarySpecialist.generate(logs);

  return InsightsData(
    insights: insights,
    weeklySummary: weeklySummary,
    logs: logs,
  );
});
