import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/daily_log.dart';
import '../../../domain/entities/routine_task.dart';
import '../../providers/settings_provider.dart';
import '../../providers/routine_provider.dart';
import '../../providers/streak_provider.dart';
import '../../providers/message_provider.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/sleep_status_banner.dart';
import '../../widgets/completion_ring.dart';
import '../../widgets/condition_toggle.dart';
import '../../../core/constants.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final eveningTasksAsync =
        ref.watch(routineTasksProvider(RoutineType.evening));
    final morningTasksAsync =
        ref.watch(routineTasksProvider(RoutineType.morning));
    final todayLogAsync = ref.watch(todayLogProvider);
    final scoreAsync = ref.watch(sleepScoreProvider);
    final message = ref.watch(messageProvider);

    return Scaffold(
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('設定読み込みエラー: $err')),
        data: (settings) {
          if (settings == null) {
            return const Center(child: Text('初期化中...'));
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: scoreAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => const SizedBox.shrink(),
                  data: (score) => SleepStatusBanner(sleepScore: score),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildRoutineCard(
                          context: context,
                          tasksAsync: eveningTasksAsync,
                          todayLogAsync: todayLogAsync,
                          isEvening: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildRoutineCard(
                          context: context,
                          tasksAsync: morningTasksAsync,
                          todayLogAsync: todayLogAsync,
                          isEvening: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      const Text('就寝',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                      Text(
                        '${settings.bedtime.hour.toString().padLeft(2, '0')}:${settings.bedtime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textPrimary),
                      ),
                    ]),
                    const SizedBox(width: 48),
                    Column(children: [
                      const Text('起床',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                      Text(
                        '${settings.wakeTime.hour.toString().padLeft(2, '0')}:${settings.wakeTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textPrimary),
                      ),
                    ]),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('今日のコンディション',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.textSecondary)),
                      const SizedBox(height: 12),
                      todayLogAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (e, _) => const SizedBox.shrink(),
                        data: (log) => Column(
                          children: [
                            ConditionToggle(
                              label: '昼寝した？',
                              emoji: '💤',
                              value: log?.napTaken,
                              answered: log?.napTaken != null,
                              onChanged: (v) => _saveCondition(napTaken: v),
                            ),
                            ConditionToggle(
                              label: '日中眠かった？',
                              emoji: '😪',
                              value: log?.daytimeSleepiness,
                              answered: log?.daytimeSleepiness != null,
                              onChanged: (v) => _saveCondition(sleepiness: v),
                            ),
                              ConditionToggle(
                                label: 'イライラした？',
                                emoji: '😤',
                                value: log?.feltIrritable,
                                answered: log?.feltIrritable != null,
                                onChanged: (v) => _saveCondition(irritability: v),
                              ),
                              const SizedBox(height: 16),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('夢メモ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary)),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'どんな夢を見た？（覚えている範囲でな）',
                                  hintStyle: const TextStyle(fontSize: 14),
                                  filled: true,
                                  fillColor: AppColors.cardBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                maxLines: 2,
                                controller: TextEditingController(text: log?.dreamNote),
                                onSubmitted: (v) => _saveCondition(dreamNote: v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 1:
              context.push('/history');
              break;
            case 2:
              context.push('/insights');
              break;
            case 3:
              context.push('/settings');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'ホーム'),
          NavigationDestination(
              icon: Icon(Icons.calendar_today), label: '履歴'),
          NavigationDestination(
              icon: Icon(Icons.insights), label: 'インサイト'),
          NavigationDestination(icon: Icon(Icons.settings), label: '設定'),
        ],
      ),
    );
  }

  Widget _buildRoutineCard({
    required BuildContext context,
    required AsyncValue<List<RoutineTask>> tasksAsync,
    required AsyncValue<DailyLog?> todayLogAsync,
    required bool isEvening,
  }) {
    final icon = isEvening ? Icons.nightlight_round : Icons.wb_sunny;
    final title = isEvening ? '夜ルーティン' : '朝ルーティン';
    final route = isEvening ? '/routine/evening' : '/routine/morning';

    return tasksAsync.when(
      loading: () => const Card(
        color: AppColors.cardBackground,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (err, st) => Card(
        color: AppColors.cardBackground,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: Text('エラー: $err')),
        ),
      ),
      data: (tasks) {
        final completedIds = todayLogAsync.value?.completedTaskIds ?? [];
        final completedCount =
            tasks.where((t) => completedIds.contains(t.id)).length;
        final totalCount = tasks.length;

        return GestureDetector(
          onTap: () => context.push(route),
          child: Card(
            color: AppColors.cardBackground,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 24, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(title,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary)),
                        ],
                      ),
                      CompletionRing(
                          completed: completedCount, total: totalCount),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('$completedCount/$totalCount 完了',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

   Future<void> _saveCondition(
      {bool? napTaken, bool? sleepiness, bool? irritability, String? dreamNote}) async {
    final logRepo = ref.read(logRepositoryProvider);
    final existing = await logRepo.getTodayLog();
    final log = existing ?? DailyLog(date: DateTime.now());
    final updated = log.copyWith(
      napTaken: napTaken ?? log.napTaken,
      daytimeSleepiness: sleepiness ?? log.daytimeSleepiness,
      feltIrritable: irritability ?? log.feltIrritable,
      dreamNote: dreamNote ?? log.dreamNote,
    );
    await logRepo.saveLog(updated);
  }
}
