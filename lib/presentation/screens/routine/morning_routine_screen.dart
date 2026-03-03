import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/daily_log.dart';
import '../../../domain/entities/routine_task.dart';
import '../../providers/routine_provider.dart';
import '../../../core/constants.dart';
import '../../widgets/completion_ring.dart';

class MorningRoutineScreen extends ConsumerStatefulWidget {
  const MorningRoutineScreen({super.key});

  @override
  ConsumerState<MorningRoutineScreen> createState() => _MorningRoutineScreenState();
}

class _MorningRoutineScreenState extends ConsumerState<MorningRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(routineTasksProvider(RoutineType.morning));
    final todayLogAsync = ref.watch(todayLogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('朝ルーティン'),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('エラー: $err')),
        data: (tasks) {
          return todayLogAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(child: Text('ログエラー: $err')),
            data: (log) {
              final completedTaskIds = log?.completedTaskIds ?? [];
              final allCompleted = tasks.isNotEmpty &&
                  tasks.every((t) => completedTaskIds.contains(t.id));

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        final isCompleted = completedTaskIds.contains(task.id);
                        return CheckboxListTile(
                          title: Text(task.title),
                          value: isCompleted,
                          onChanged: (val) {
                            ref
                                .read(routineProvider.notifier)
                                .toggleTask(task.id, log);
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CompletionRing(
                          completed: completedTaskIds
                              .where((id) => tasks.any((t) => t.id == id))
                              .length,
                          total: tasks.length,
                          size: 80,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: allCompleted && !(log?.morningCompleted ?? false)
                                ? () => _showCompletionDialog(context, log!)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(log?.morningCompleted == true
                                ? '完了済み'
                                : 'ルーティンを完了する'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showCompletionDialog(BuildContext context, DailyLog log) async {
    final result = await showDialog<(DateTime?, DateTime?, TimeOfDay?, TimeOfDay?)>(
      context: context,
      builder: (context) => _SleepTimeDialog(),
    );

    if (result != null) {
      final bedTime = result.$1;
      final wakeTime = result.$2;
      final idealBedTime = result.$3;
      final idealWakeTime = result.$4;

      if (bedTime != null && wakeTime != null) {
        await ref
            .read(routineProvider.notifier)
            .completeMorningRoutineWithSleep(log, bedTime, wakeTime, idealBedTime, idealWakeTime);
      } else {
        await ref.read(routineProvider.notifier).completeMorningRoutine(log);
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}

class _SleepTimeDialog extends StatefulWidget {
  @override
  State<_SleepTimeDialog> createState() => _SleepTimeDialogState();
}

class _SleepTimeDialogState extends State<_SleepTimeDialog> {
  DateTime? bedTime;
  DateTime? wakeTime;
  TimeOfDay? idealBedTime;
  TimeOfDay? idealWakeTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('昨夜の睡眠を記録'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('昨夜は何時に寝て、今朝は何時に起きましたか？'),
          const SizedBox(height: 16),
          // 就寝時間
          ListTile(
            leading: const Icon(Icons.nightlight_round, color: Colors.indigo),
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
                initialTime: bedTime != null
                    ? TimeOfDay(hour: bedTime!.hour, minute: bedTime!.minute)
                    : const TimeOfDay(hour: 23, minute: 0),
              );
              if (picked != null) {
                setState(() {
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
                initialTime: wakeTime != null
                    ? TimeOfDay(hour: wakeTime!.hour, minute: wakeTime!.minute)
                    : const TimeOfDay(hour: 6, minute: 30),
              );
              if (picked != null) {
                setState(() {
                  wakeTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                });
              }
            },
          ),
          const Divider(),
          // 理想時間
          ListTile(
            leading: const Icon(Icons.brightness_5, color: Colors.purple),
            title: const Text('理想就寝時間'),
            subtitle: Text(
              idealBedTime != null
                  ? '${idealBedTime!.hour.toString().padLeft(2, '0')}:${idealBedTime!.minute.toString().padLeft(2, '0')}'
                  : '設定しない',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final now = DateTime.now();
              final picked = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 22, minute: 30),
              );
              if (picked != null) {
                setState(() {
                  idealBedTime = picked;
                });
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.wb_twilight, color: Colors.blue),
            title: const Text('理想起床時間'),
            subtitle: Text(
              idealWakeTime != null
                  ? '${idealWakeTime!.hour.toString().padLeft(2, '0')}:${idealWakeTime!.minute.toString().padLeft(2, '0')}'
                  : '設定しない',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final now = DateTime.now();
              final picked = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 6, minute: 30),
              );
              if (picked != null) {
                setState(() {
                  idealWakeTime = picked;
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
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, (null, null)),
          child: const Text('スキップ'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, (bedTime, wakeTime, idealBedTime, idealWakeTime)),
          child: const Text('記録する'),
        ),
      ],
    );
  }

  String _calculateSleepDuration(DateTime bedTime, DateTime wakeTime) {
    final duration = wakeTime.difference(bedTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '$hours時間${minutes > 0 ? ' $minutes分' : ''}';
  }
}
