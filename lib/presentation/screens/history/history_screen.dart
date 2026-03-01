import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/streak_provider.dart';
import '../../providers/routine_provider.dart';
import '../../providers/repository_providers.dart';
import '../../../domain/entities/daily_log.dart';
import '../../../core/constants.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final maxStreak = ref.watch(longestStreakProvider);
    final todayLogAsync = ref.watch(todayLogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ストリークカード
            Card(
              color: AppColors.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '現在ストリーク',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, color: AppColors.accent, size: 32),
                        const SizedBox(width: 8),
                        Text(
                          '${streak.value ?? 0} 日',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 最長ストリーク
            Card(
              color: AppColors.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '最長ストリーク',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: AppColors.badgeUnlocked, size: 32),
                        const SizedBox(width: 8),
                        Text(
                          '${maxStreak.value ?? 0} 日',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.badgeUnlocked,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '過去30日',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: todayLogAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, st) => Center(child: Text('エラー: $err')),
                data: (todayLog) {
                  // 過去30日を取得（今日を除く）
                  final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  return FutureBuilder<List<DailyLog>>(
                    future: ref.read(logRepositoryProvider).getRecentLogs(31),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final logs = snapshot.data!;
                      // 今日を除いてソート
                      final filteredLogs = logs
                          .where((log) => DateFormat('yyyy-MM-dd').format(log.date) != todayKey)
                          .toList()
                        ..sort((a, b) => b.date.compareTo(a.date));

                      if (filteredLogs.isEmpty) {
                        return const Center(child: Text('履歴がありません'));
                      }

                      return ListView.builder(
                        itemCount: filteredLogs.length,
                        itemBuilder: (context, index) {
                          final log = filteredLogs[index];
                          return Card(
                            color: AppColors.cardBackground,
                            child: ListTile(
                              leading: _buildLeadingIcon(log),
                              title: Text(
                                DateFormat('MM/dd').format(log.date),
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  _buildStatusIcon('evening', log.eveningCompleted, log.eveningCompletedAt),
                                  const SizedBox(width: 8),
                                  _buildStatusIcon('morning', log.morningCompleted, log.morningCompletedAt),
                                  const SizedBox(width: 8),
                                  if (log.napTaken == true) const Text('💤', style: TextStyle(fontSize: 16)),
                                  if (log.daytimeSleepiness == true) const Text('😪', style: TextStyle(fontSize: 16)),
                                  if (log.feltIrritable == true) const Text('😤', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(DailyLog log) {
    if (log.eveningCompleted && log.morningCompleted) {
      return const Icon(Icons.check_circle, color: AppColors.success, size: 28);
    }
    return const Icon(Icons.radio_button_unchecked, color: AppColors.textSecondary, size: 28);
  }

  Widget _buildStatusIcon(String label, bool completed, DateTime? completedAt) {
    if (completed) {
      return Icon(
        label == 'evening' ? Icons.nightlight_round : Icons.wb_sunny,
        color: AppColors.success,
        size: 20,
      );
    }
    return Icon(
      label == 'evening' ? Icons.nightlight_outlined : Icons.wb_sunny_outlined,
      color: AppColors.textSecondary,
      size: 20,
    );
  }
}
