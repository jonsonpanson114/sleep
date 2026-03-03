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
              // 実際vs理想の睡眠時間を比較
              _buildActualVsIdealTimeCard(analytics, summary),
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
                      const SizedBox(height: 16),
                      const Icon(Icons.bar_chart, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
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

  Widget _buildActualVsIdealTimeCard(SleepAnalyticsResult analytics, WeeklySummary summary) {
    // 最新のログから実時間を取得
    final recentLogs = summary.recentLogs;
    if (recentLogs.isEmpty) return const SizedBox.shrink();

    final latestLog = recentLogs.first;
    final actualBedTime = latestLog.bedTime;
    final actualWakeTime = latestLog.wakeTime;
    final idealBedTime = latestLog.idealBedTime;
    final idealWakeTime = latestLog.idealWakeTime;
    final fatigueLevel = analytics.fatigueLevel;
    final suggestEarly = analytics.suggestEarlySleep;

    return Card(
      margin: const EdgeInsets.all(8.0, bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF607D8B), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.compare_arrows, color: AppColors.accent, size: 20),
                SizedBox(width: 8),
                Text(
                  '実際 vs 理想',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 実際就寝時間 vs 理想就寝時間
            _buildTimeComparisonRow('就寝', actualBedTime, idealBedTime),
            const SizedBox(height: 16),
            // 実際起床時間 vs 理想起床時間
            _buildTimeComparisonRow('起床', actualWakeTime, idealWakeTime),
            if (actualBedTime != null && idealBedTime != null) ...[
              const SizedBox(height: 16),
              _buildAnalysisMessage(actualBedTime, idealBedTime, '就寝'),
            ],
            if (actualWakeTime != null && idealWakeTime != null) ...[
              const SizedBox(height: 16),
              _buildAnalysisMessage(actualWakeTime, idealWakeTime, '起床'),
            ],
            // 疲労度・提案
            if (fatigueLevel != null) ...[
              const SizedBox(height: 20),
              _buildFatigueStatus(fatigueLevel!),
            ],
            if (suggestEarlySleep != null && suggestEarlySleep!) ...[
              const SizedBox(height: 16),
              _buildSuggestion(suggestEarlySleep),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeComparisonRow(String label, DateTime? actual, TimeOfDay? ideal) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            '$label：',
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ),
        const SizedBox(width: 8),
        // 実際時間
        Expanded(
          child: _buildTimeDisplay(actual != null ? actual : '設定しない'),
        ),
        const SizedBox(width: 8),
        // 理想時間
        Expanded(
          child: _buildTimeDisplay(ideal != null ? ideal : '設定しない'),
        ),
        const SizedBox(width: 16),
        // 比較アイコン
        Icon(
          ideal != null && actual != null
              ? Icons.compare
              : Icons.compare_arrows,
          color: ideal != null && actual != null && ideal.hour < actual.hour
              ? Colors.green
              : ideal != null && actual != null && ideal.hour > actual.hour
              ? Colors.red
              : Colors.white70,
          size: 24,
        ),
      ],
    );
  }

  Widget _buildAnalysisMessage(DateTime actual, TimeOfDay ideal, String type) {
    final hourDiff = ideal.hour - actual.hour;
    final minuteDiff = ideal.minute - actual.minute;

    if (hourDiff.abs() <= 1 && minuteDiff.abs() <= 30) {
      return Text(
        '✓ 1時間以内の差異',
        style: const TextStyle(color: Colors.green, fontSize: 12),
      );
    } else if (hourDiff.abs() <= 2) {
      return Text(
        '${hourDiff.abs()}時間の差異',
        style: const TextStyle(color: Colors.orange, fontSize: 12),
      );
    } else {
      return Text(
        '${hourDiff.abs()}時間以上の差異',
        style: const TextStyle(color: Colors.red, fontSize: 12),
      );
    }
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

  Widget _buildFatigueStatus(double level) {
    String label;
    IconData icon;
    Color color;

    if (level <= 0.4) {
      label = '良好';
      icon = Icons.sentiment_very_satisfied;
      color = Colors.green;
    } else if (level <= 0.6) {
      label = '少し疲れ';
      icon = Icons.sentiment_satisfied;
      color = Colors.lightGreen;
    } else {
      label = '疲れ';
      icon = Icons.sentiment_dissatisfied;
      color = Colors.orange;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          '疲労度: $label',
          style: const TextStyle(fontSize: 13, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildSuggestion(bool suggestEarlySleep) {
    if (suggestEarlySleep) {
      return Row(
        children: [
          const Icon(Icons.bedtime, color: Colors.yellow, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '今日は早めに寝ることを推奨します。',
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
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
}
