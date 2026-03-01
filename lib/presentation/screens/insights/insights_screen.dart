import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/insights_provider.dart';
import '../../widgets/insight_card.dart';
import '../../../core/constants.dart';
import '../../widgets/weekly_summary_card.dart';
import '../../widgets/weekly_pattern_chart.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(insightsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('インサイト'),
      ),
      body: insightsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('エラー: $err')),
        data: (data) {
          final insights = data.insights;
          final summary = data.weeklySummary;
          final pattern = data.weeklyPattern;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 斎藤さんの週間総括
              WeeklySummaryCard(summary: summary),
              const SizedBox(height: 20),

              // 曜日別傾向グラフ
              WeeklyPatternChart(pattern: pattern),
              const SizedBox(height: 20),

              // 相関インサイト
              if (insights.isNotEmpty) ...[
                const Text(
                  '🔍 見えてきた傾向',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ...insights.map((insight) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: InsightCard(insight: insight),
                    )),
              ] else ...[
                const Center(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Icon(Icons.bar_chart, size: 48, color: AppColors.textSecondary),
                      SizedBox(height: 12),
                      Text(
                        '相関データ収集中',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '日中のコンディションを記録すると\n睡眠との相関が見えてきます',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}
