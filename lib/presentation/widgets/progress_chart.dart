import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import 'package:fl_chart/fl_chart.dart';

/// 睡眠 × コンディションの相関を表示する散布図
class ProgressChart extends StatelessWidget {
  final Map<String, bool> bedtimeData;  // {dateKey: isEarlyBedtime}
  final Map<String, bool> sleepinessData;  // {dateKey: hadSleepiness}

  const ProgressChart({
    super.key,
    required this.bedtimeData,
    required this.sleepinessData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '就寝時刻 vs 日中の眠気',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ScatterChart(
                ScatterChartData(
                  scatterSpots: [
                    ..._getBedtimeSpots(),
                    ..._getSleepinessSpots(),
                  ],
                  minX: -0.5,
                  maxX: 1.5,
                  minY: -0.5,
                  maxY: 1.5,
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  scatterTouchData: ScatterTouchData(enabled: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ScatterSpot> _getBedtimeSpots() {
    final spots = <ScatterSpot>[];
    bedtimeData.forEach((dateKey, isEarly) {
      final x = isEarly ? 0.3 : 0.8;
      spots.add(ScatterSpot(x, _randomY(), show: true));
    });
    return spots;
  }

  List<ScatterSpot> _getSleepinessSpots() {
    final spots = <ScatterSpot>[];
    sleepinessData.forEach((dateKey, hadSleepiness) {
      final x = hadSleepiness ? 0.7 : 1.2;
      spots.add(ScatterSpot(x, _randomY(), show: true));
    });
    return spots;
  }

  double _randomY() {
    // Y軸の位置をランダムにして見やすくする
    return (DateTime.now().millisecond % 100) / 100 * 0.8 + 0.1;
  }
}
