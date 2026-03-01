import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/streak_provider.dart';
import '../../providers/missions_provider.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/stamp_calendar.dart';
import '../../widgets/mission_card.dart';
import '../../../domain/entities/daily_log.dart';
import '../../../core/constants.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streakAsync = ref.watch(streakProvider);
    final maxStreakAsync = ref.watch(longestStreakProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.calendar_month), text: 'スタンプ'),
            Tab(icon: Icon(Icons.flag), text: 'ミッション'),
          ],
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.accent,
        ),
      ),
      body: Column(
        children: [
          // ストリーク情報バー
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                streakAsync.when(
                  loading: () => const _StatItem(label: '現在', value: '-', emoji: '🔥'),
                  error: (_, __) => const _StatItem(label: '現在', value: '0', emoji: '🔥'),
                  data: (s) => _StatItem(label: '現在の連続', value: '$s日', emoji: '🔥'),
                ),
                const VerticalDivider(color: AppColors.textSecondary),
                maxStreakAsync.when(
                  loading: () => const _StatItem(label: '最高記録', value: '-', emoji: '🏆'),
                  error: (_, __) => const _StatItem(label: '最高記録', value: '0', emoji: '🏆'),
                  data: (s) => _StatItem(label: '最高記録', value: '$s日', emoji: '🏆'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // タブ1: スタンプカレンダー
                _CalendarTab(),
                // タブ2: ミッション
                _MissionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _StatItem({
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _CalendarTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<DailyLog>>(
      future: ref.read(logRepositoryProvider).getRecentLogs(90),
      builder: (context, snapshot) {
        final logs = snapshot.data ?? [];
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              StampCalendar(logs: logs),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class _MissionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionsAsync = ref.watch(weeklyMissionsProvider);

    return missionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('エラー: $e')),
      data: (missions) {
        final completed = missions.where((m) => m.isCompleted).length;
        final total = missions.length;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 今週の進捗サマリー
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.15),
                    AppColors.primary.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Text(
                    '$completed/$total',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '今週のミッション達成',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: total > 0 ? completed / total : 0,
                            minHeight: 8,
                            backgroundColor:
                                AppColors.cardBackground,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ミッション一覧
            ...missions.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MissionCard(mission: m),
                )),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}
