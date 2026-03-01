import 'package:flutter/material.dart' show TimeOfDay, BuildContext, Color, Column, Center, Card, ColorScheme, Container, CrossAxisAlignment, BoxShadow, BorderRadius, BoxShadow, Colors, CircularProgressIndicator, Divider, EdgeInsets, Expanded, FontWeight, FontStyle, GridView, Icon, IconButton, Icons, LinearGradient, ListView, MainAxisAlignment, MediaQuery, Offset, Padding, Radius, RoundedRectangleBorder, Row, Scaffold, SingleTickerProviderStateMixin, SizedBox, SliverGridDelegateWithFixedCrossAxisCount, SliverToBoxAdapter, SnackBar, Spacer, Stack, State, StatefulWidget, Text, TextButton, TextStyle, Theme, VerticalDivider, Widget, WidgetStateProperty;
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
          final analytics = data.analytics;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 斎藤さんの週間総括
              WeeklySummaryCard(summary: summary),
              const SizedBox(height: 20),

              // 黄金の睡眠時間（ベストタイム）
              _buildBestTimeCard(analytics),
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
                      const Text(
                        '相関データ収集中',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
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

  Widget _buildBestTimeCard(dynamic analytics) {
    final bestBed = analytics.bestBedtime;
    final bestWake = analytics.bestWakeTime;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF303F9F), Color(0xFF1A237E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.accent, size: 20),
              SizedBox(width: 8),
              Text(
                '解析：黄金の睡眠時間',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (bestBed != null && bestWake != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeDisplay('就寝', bestBed),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('〜', style: TextStyle(fontSize: 24, color: Colors.white)),
                ),
                _buildTimeDisplay('起床', bestWake),
              ],
            )
          else
            const Center(
              child: Text(
                '解析まであと数日記録が必要です',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            analytics.insightMessage,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay(String label, dynamic time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return Column(
      children: [
         Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
         Text(
          '$hour:$minute',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}
