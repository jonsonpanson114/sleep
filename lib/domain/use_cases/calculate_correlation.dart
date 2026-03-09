import '../entities/daily_log.dart';

enum InsightType { positive, warning, neutral }

class CorrelationInsight {
  final String title;
  final String description;
  final InsightType type;

  const CorrelationInsight({
    required this.title,
    required this.description,
    required this.type,
  });
}

class CalculateCorrelation {
  /// 睡眠時刻とコンディションの相関を分析
  List<CorrelationInsight> execute(List<DailyLog> logs) {
    final insights = <CorrelationInsight>[];

    if (logs.isEmpty) return insights;

    // 早期就寝と日中眠気の相関
    final earlyBedDays = logs.where((l) => _isEarlyBedtime(l)).toList();
    final lateBedDays = logs.where((l) => !_isEarlyBedtime(l)).toList();

    if (earlyBedDays.isNotEmpty && lateBedDays.isNotEmpty) {
      final earlyBedSleepinessRate = _countCondition(
            earlyBedDays,
            (l) => l.daytimeSleepiness == true,
          ) /
          earlyBedDays.length;
      final lateBedSleepinessRate = _countCondition(
            lateBedDays,
            (l) => l.daytimeSleepiness == true,
          ) /
          lateBedDays.length;

      if (lateBedSleepinessRate > earlyBedSleepinessRate + 0.2) {
        final reduction = ((1 - earlyBedSleepinessRate / lateBedSleepinessRate) * 100)
            .clamp(10, 90)
            .toInt();
        insights.add(CorrelationInsight(
          title: '早期就寝と日中眠気の相関',
          description:
              '22:30以前に寝た日は、日中の眠気が$reduction%減少しています',
          type: InsightType.positive,
        ));
      }
    }

    // 両ルーティン達成とイライラの相関
    final completedDays = logs
        .where((l) => l.eveningCompleted && l.morningCompleted)
        .toList();
    final uncompletedDays = logs
        .where((l) => !(l.eveningCompleted && l.morningCompleted))
        .toList();

    if (completedDays.isNotEmpty && uncompletedDays.isNotEmpty) {
      final completedIrritableRate = _countCondition(
            completedDays,
            (l) => l.feltIrritable == true,
          ) /
          completedDays.length;
      final uncompletedIrritableRate = _countCondition(
            uncompletedDays,
            (l) => l.feltIrritable == true,
          ) /
          uncompletedDays.length;

      if (completedIrritableRate < uncompletedIrritableRate - 0.2) {
        final reduction = ((uncompletedIrritableRate - completedIrritableRate) * 100)
            .clamp(10, 90)
            .toInt();
        insights.add(CorrelationInsight(
          title: 'ルーティン達成とイライラの相関',
          description:
              '両ルーティン達成日は、イライラが$reduction%減少しています',
          type: InsightType.positive,
        ));
      }
    }

    return insights;
  }

  bool _isEarlyBedtime(DailyLog log) {
    if (log.eveningCompletedAt == null) return false;
    return log.eveningCompletedAt!.hour < 22 ||
        (log.eveningCompletedAt!.hour == 22 &&
            log.eveningCompletedAt!.minute <= 30);
  }

  int _countCondition(List<DailyLog> logs, bool Function(DailyLog) condition) {
    return logs.where(condition).length;
  }
}
