import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants.dart';
import '../../../domain/use_cases/calculate_weekly_pattern.dart';

class WeeklyPatternChart extends StatelessWidget {
  final WeeklyPatternResult pattern;

  const WeeklyPatternChart({super.key, required this.pattern});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '曜日別ルーティン達成率',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildChip(
                    '平日 ${(pattern.weekdayAvg * 100).toInt()}%',
                    const Color(0xFF42A5F5)),
                const SizedBox(width: 8),
                _buildChip(
                    '週末 ${(pattern.weekendAvg * 100).toInt()}%',
                    const Color(0xFFAB47BC)),
                if (pattern.bestDay != null) ...[
                  const Spacer(),
                  Text(
                    '🥇 ${pattern.bestDay}曜日',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1.0,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (groupIndex < 0 || groupIndex >= pattern.byDayOfWeek.length) return null;
                        final stat = pattern.byDayOfWeek[groupIndex];
                        return BarTooltipItem(
                          '${stat.label}曜\n${(stat.completionRate * 100).toInt()}%',
                          const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= pattern.byDayOfWeek.length) return const SizedBox.shrink();
                          final day = pattern.byDayOfWeek[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              day.label,
                              style: TextStyle(
                                fontSize: 12,
                                color: day.isWeekend
                                    ? const Color(0xFFAB47BC)
                                    : AppColors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 0.5,
                        getTitlesWidget: (value, meta) => Text(
                          '${(value * 100).toInt()}%',
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textSecondary),
                        ),
                        reservedSize: 36,
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.textSecondary.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: pattern.byDayOfWeek.asMap().entries.map((entry) {
                    final i = entry.key;
                    final stat = entry.value;
                    final color = stat.isWeekend
                        ? const Color(0xFFAB47BC)
                        : const Color(0xFF42A5F5);
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: stat.completionRate,
                          color: color,
                          width: 22,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6)),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 1.0,
                            color: color.withOpacity(0.1),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
