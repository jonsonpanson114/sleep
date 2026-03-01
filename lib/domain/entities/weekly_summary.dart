class WeeklySummary {
  final String dateRange;
  final String content;
  final double averageSleepQuality; // 0.0 to 1.0 based on daytime condition
  final double routineCompletionRate;

  WeeklySummary({
    required this.dateRange,
    required this.content,
    required this.averageSleepQuality,
    required this.routineCompletionRate,
  });
}
