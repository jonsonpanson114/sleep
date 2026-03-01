import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/weekly_report_provider.dart';
import '../../../domain/entities/weekly_report.dart';
import '../../../core/constants.dart';

class WeeklyReportScreen extends ConsumerWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(weeklyReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('週レポート'),
      ),
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('エラー: $err')),
        data: (report) {
          if (report == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text(
                    'まだデータが足りません',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildRateCard(report),
                const SizedBox(height: 16),
                _buildTimeCard(report),
                const SizedBox(height: 16),
                _buildStreakCard(report),
                const SizedBox(height: 16),
                _buildConditionCard(report),
                const SizedBox(height: 16),
                _buildInsightCard(report),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRateCard(WeeklyReport report) {
    final previousDiff = report.previousWeekRate != null
        ? (report.completionRate - report.previousWeekRate! * 100).toInt()
        : null;
    final diffColor = previousDiff != null && previousDiff > 0
        ? AppColors.success
        : (previousDiff != null && previousDiff < 0)
            ? AppColors.danger
            : AppColors.textSecondary;
    final diffText = previousDiff != null
        ? (previousDiff > 0 ? '+$previousDiff%' : '$previousDiff%')
        : '-';

    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '達成率',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${(report.completionRate * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (previousDiff != null) ...[
                  const SizedBox(width: 16),
                  Text(
                    diffText,
                    style: TextStyle(
                      fontSize: 20,
                      color: diffColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '（先週比）',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(WeeklyReport report) {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '平均就寝時刻',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              '${report.averageBedtime.hour.toString().padLeft(2, '0')}:${report.averageBedtime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '平均起床時刻',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              '${report.averageWakeTime.hour.toString().padLeft(2, '0')}:${report.averageWakeTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(WeeklyReport report) {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'ストリーク',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      '現在',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    Text(
                      '${report.currentStreak}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                    Text(
                      '連続達成',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      '最長',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    Text(
                      '${report.maxStreak}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.badgeUnlocked,
                      ),
                    ),
                    Text(
                      '連続達成',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionCard(WeeklyReport report) {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'コンディション',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildConditionRow('💤', '昼寝', report.napDays, report.weekStart.difference(report.weekEnd).inDays),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildConditionRow('😪', '眠かった', report.sleepinessDays, report.weekStart.difference(report.weekEnd).inDays),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildConditionRow('😤', 'イライラ', report.irritableDays, report.weekStart.difference(report.weekEnd).inDays),
                ),
                const SizedBox(width: 16),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionRow(String emoji, String label, int days, int totalDays) {
    final percentage = totalDays > 0 ? (days / totalDays * 100).toInt() : 0;

    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          '$days/$totalDays日',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: percentage >= 50 ? AppColors.danger : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(WeeklyReport report) {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: AppColors.accent, size: 24),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'インサイト',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              report.insightMessage,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
