import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/calculate_correlation.dart';
import 'repository_providers.dart';

final insightsProvider = FutureProvider<List<CorrelationInsight>>((ref) async {
  final repo = ref.watch(logRepositoryProvider);
  final logs = await repo.getRecentLogs(90);
  final calculator = CalculateCorrelation();
  return calculator.execute(logs);
});
