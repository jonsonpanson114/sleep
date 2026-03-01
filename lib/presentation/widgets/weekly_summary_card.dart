import 'package:flutter/material.dart';
import '../../../domain/entities/weekly_summary.dart';
import '../../../core/constants.dart';

class WeeklySummaryCard extends StatelessWidget {
  final WeeklySummary summary;

  const WeeklySummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.accent.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.accent, size: 24),
                const SizedBox(width: 8),
                Text(
                  '世界一の睡眠専門家・斎藤の総括',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent.withOpacity(0.8),
                  ),
                ),
                const Spacer(),
                Text(
                  summary.dateRange,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              summary.content,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildStat('達成率', '${(summary.routineCompletionRate * 100).toInt()}%'),
                const SizedBox(width: 24),
                _buildStat('睡眠の質', '${(summary.averageSleepQuality * 100).toInt()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }
}
