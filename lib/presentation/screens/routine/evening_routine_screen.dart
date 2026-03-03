import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/routine_task.dart';
import '../../providers/routine_provider.dart';
import '../../widgets/night_sky_background.dart';
import '../../widgets/completion_ring.dart';
import '../../widgets/task_tile.dart';
import '../../../core/constants.dart';

class EveningRoutineScreen extends ConsumerWidget {
  const EveningRoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineAsync = ref.watch(routineTasksProvider(RoutineType.evening));
    final todayLogAsync = ref.watch(todayLogProvider);

    final todayLog = todayLogAsync.value;
    final tasks = routineAsync.value ?? [];
    final completedIds = todayLog?.completedTaskIds ?? [];
    final completionRatio =
        tasks.isEmpty ? 0.0 : completedIds.length / tasks.length;

    final allDone = tasks.isNotEmpty &&
        tasks.every((t) => completedIds.contains(t.id));
    final canComplete =
        allDone && todayLog != null && !todayLog.eveningCompleted;

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
                        TaskTile(
                          task: task,
                          isCompleted: (log?.completedTaskIds ?? [])
                              .contains(task.id),
                          onTap: () => ref
                                  .read(routineProvider.notifier)
                                  .toggleTask(task.id, log),
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
