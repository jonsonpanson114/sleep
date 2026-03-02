import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/routine_task.dart';
import '../../providers/routine_provider.dart';
import '../../widgets/completion_ring.dart';
import '../../widgets/task_tile.dart';
import '../../../core/constants.dart';

class MorningRoutineScreen extends ConsumerWidget {
  const MorningRoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineAsync = ref.watch(routineTasksProvider(RoutineType.morning));
    final todayLogAsync = ref.watch(todayLogProvider);

    final todayLog = todayLogAsync.value;
    final tasks = routineAsync.value ?? [];
    final completedIds = todayLog?.completedTaskIds ?? [];

    final allDone =
        tasks.isNotEmpty && tasks.every((t) => completedIds.contains(t.id));
    final canComplete =
        allDone && todayLog != null && !todayLog.morningCompleted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('朝ルーティン'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/routine/morning/edit'),
          ),
        ],
      ),
      body: Padding(
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
                error: (err, _) => Center(child: Text('エラー: $err')),
                data: (log) => ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    for (final task in tasks)
                      TaskTile(
                        task: task,
                        isCompleted:
                            (log?.completedTaskIds ?? []).contains(task.id),
                        onTap: log == null
                            ? null
                            : () => ref
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: canComplete
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              onPressed: () async {
                // 睡眠時間入力ダイアログを表示
                final result = await _showSleepTimeDialog(context);
                if (result != null && result.$1 != null && result.$2 != null) {
                  // 睡眠時間が入力されたらルーティンを完了
                  await ref
                      .read(routineProvider.notifier)
                      .completeMorningRoutineWithSleep(
                        todayLog,
                        result.$1!,
                        result.$2!,
                      );
                  if (context.mounted) Navigator.pop(context);
                } else {
                  // 入力なしでルーティンを完了
                  await ref
                      .read(routineProvider.notifier)
                      .completeMorningRoutine(todayLog);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              label: const Text('ルーティンを完了する'),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }

  Future<(DateTime?, DateTime?)?> _showSleepTimeDialog(BuildContext context) async {
    DateTime? bedTime;
    DateTime? wakeTime;

    return await showDialog<(DateTime?, DateTime?)>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('睡眠時間を記録'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '昨日の睡眠時間を記録できます',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                // 就寝時間
                ListTile(
                  leading: const Icon(Icons.bedtime, color: Colors.blue),
                  title: const Text('就寝時間'),
                  subtitle: Text(
                    bedTime != null
                        ? '${bedTime!.hour.toString().padLeft(2, '0')}:${bedTime!.minute.toString().padLeft(2, '0')}'
                        : '時間を選択',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 22, minute: 0),
                    );
                    if (picked != null) {
                      setState(() {
                        // 昨日の就寝時間として設定
                        bedTime = DateTime(now.year, now.month, now.day - 1, picked.hour, picked.minute);
                      });
                    }
                  },
                ),
                const Divider(),
                // 起床時間
                ListTile(
                  leading: const Icon(Icons.wb_sunny, color: Colors.orange),
                  title: const Text('起床時間'),
                  subtitle: Text(
                    wakeTime != null
                        ? '${wakeTime!.hour.toString().padLeft(2, '0')}:${wakeTime!.minute.toString().padLeft(2, '0')}'
                        : '時間を選択',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 6, minute: 30),
                    );
                    if (picked != null) {
                      setState(() {
                        // 今朝の起床時間として設定
                        wakeTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                      });
                    }
                  },
                ),
                if (bedTime != null && wakeTime != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '睡眠時間: ${_calculateSleepDuration(bedTime!, wakeTime!)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('スキップ'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, (bedTime, wakeTime)),
                child: const Text('記録する'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _calculateSleepDuration(DateTime bedTime, DateTime wakeTime) {
    final duration = wakeTime.difference(bedTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}時間${minutes > 0 ? ' $minutes分' : ''}';
  }
}
