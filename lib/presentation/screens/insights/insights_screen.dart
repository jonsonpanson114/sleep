import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/insights_provider.dart';
import '../../widgets/insight_card.dart';
import '../../../core/constants.dart';
import '../../widgets/weekly_summary_card.dart';

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
        error: (err, st) => Center(
                child: Text('エラー: $err'),
              ),
        data: (data) {
          final insights = data.insights;
          final summary = data.weeklySummary;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              WeeklySummaryCard(summary: summary),
              const SizedBox(height: 24),
              if (insights.isEmpty) ...[
                const Center(
                  child: Column(
                    children: [
                      SizedBox(height: 32),
                      Icon(Icons.bar_chart, size: 64, color: AppColors.textSecondary),
                      SizedBox(height: 16),
                      Text(
                        '分析データ収集中',
                        style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '日中のコンディションを記録していくと、\n'
                        '睡眠の質との相関が見えてきます。',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const Text(
                  '見えてきた傾向',
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
              ],
            ],
          );
        },
      ),
    );
  }
}
