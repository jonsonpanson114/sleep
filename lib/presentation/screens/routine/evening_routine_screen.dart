import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/routine_task.dart';
import '../../providers/routine_provider.dart';
import '../../widgets/night_sky_background.dart';
import '../../widgets/completion_ring.dart';
import '../../../core/constants.dart';

class EveningRoutineScreen extends ConsumerStatefulWidget {
  const EveningRoutineScreen({super.key});

  @override
  ConsumerState<EveningRoutineScreen> createState() => _EveningRoutineScreenState();
}

class _EveningRoutineScreenState extends ConsumerState<EveningRoutineScreen> {
  Future<void> _onTimeTap(BuildContext context, RoutineTask task) async {
    TimeOfDay? parseTime(String? s) {
      if (s == null || !s.contains(':')) return null;
      final parts = s.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    String fmt(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    final start = await showTimePicker(
      context: context,
      initialTime: parseTime(task.startTime) ?? TimeOfDay.now(),
      helpText: '開始時間',
    );
    if (start == null) return;
    if (!mounted) return;
    final end = await showTimePicker(
      context: context,
      initialTime: parseTime(task.endTime) ?? start,
      helpText: '終了時間',
    );
    if (end == null) return;
    ref.read(routineProvider.notifier).updateTask(
          task.copyWith(startTime: fmt(start), endTime: fmt(end)),
        );
  }

  @override
  Widget build(BuildContext context) {
    final routineAsync = ref.watch(routineTasksProvider(RoutineType.evening));
    final todayLogAsync = ref.watch(todayLogProvider);

    final todayLog = todayLogAsync.value;
    final tasks = routineAsync.value ?? [];
    final completedIds = todayLog?.completedTaskIds ?? [];
    final completionRatio =
        tasks.isEmpty ? 0.0 : completedIds.length / tasks.length;

    final canComplete =
        todayLog != null && !todayLog.eveningCompleted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('就寝ルーティン'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/routine/evening/edit'),
          ),
        ],
      ),
      body: NightSkyBackground(
        completionRatio: completionRatio,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CompletionRing(
                completed: completedIds.length,
                total: tasks.length,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: todayLogAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) =>
                      Center(child: Text('エラー: $err')),
                  data: (log) => ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      for (final task in tasks)
                        CheckboxListTile(
                          value: (log?.completedTaskIds ?? [])
                              .contains(task.id),
                          title: Text(task.title),
                          subtitle: (task.startTime != null || task.endTime != null)
                              ? Text(
                                  '${task.startTime ?? '--:--'} - ${task.endTime ?? '--:--'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                )
                              : null,
                          secondary: IconButton(
                            icon: Icon(
                              Icons.access_time,
                              size: 20,
                              color: (task.startTime != null)
                                  ? AppColors.primary
                                  : Colors.white54,
                            ),
                            tooltip: '時間を設定',
                            onPressed: () => _onTimeTap(context, task),
                          ),
                          onChanged: (_) => ref
                                  .read(routineProvider.notifier)
                                  .toggleTask(task.id),
                          activeColor: AppColors.success,
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: canComplete
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              onPressed: () async {
                await ref
                    .read(routineProvider.notifier)
                    .completeEveningRoutine(todayLog);
                if (context.mounted) Navigator.pop(context);
              },
              label: const Text('ルーティンを完了する'),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
