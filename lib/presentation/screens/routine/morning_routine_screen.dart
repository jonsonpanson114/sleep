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
                  _buildSleepTimeSection(context, log),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                .toggleTask(task.id);
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

  Widget _buildSleepTimeSection(BuildContext context, DailyLog? log) {
    final hasSleepData = log?.bedTime != null && log?.wakeTime != null;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '昨夜の睡眠',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton.icon(
                onPressed: () => _showSleepInputDialog(context, log),
                icon: Icon(hasSleepData ? Icons.edit : Icons.add, size: 18),
                label: Text(hasSleepData ? '編集' : '記録する'),
              ),
            ],
          ),
          if (hasSleepData) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.nightlight_round, size: 16, color: Colors.indigo),
                const SizedBox(width: 4),
                Text('${log!.bedTime!.hour.toString().padLeft(2, '0')}:${log.bedTime!.minute.toString().padLeft(2, '0')}'),
                const Text('  〜  '),
                const Icon(Icons.wb_sunny, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text('${log.wakeTime!.hour.toString().padLeft(2, '0')}:${log.wakeTime!.minute.toString().padLeft(2, '0')}'),
                const Spacer(),
                Text(
                  '睡眠時間: ${log.sleepDurationMinutes != null ? (log.sleepDurationMinutes! / 60).floor() : 0}時間${log.sleepDurationMinutes != null ? log.sleepDurationMinutes! % 60 : 0}分',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ] else
            const Text('睡眠時間がまだ記録されていません', style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Future<void> _showSleepInputDialog(BuildContext context, DailyLog? log) async {
    final result = await showDialog<(DateTime?, DateTime?, TimeOfDay?, TimeOfDay?)>(
      context: context,
      builder: (context) => _SleepTimeDialog(
        initialBedTime: log?.bedTime,
        initialWakeTime: log?.wakeTime,
        initialIdealBedTime: log?.idealBedTime,
        initialIdealWakeTime: log?.idealWakeTime,
      ),
    );

    if (result != null && result.$1 != null && result.$2 != null) {
      await ref.read(routineProvider.notifier).updateSleepTime(
            log: log ?? DailyLog(date: DateTime.now(), completedTaskIds: []),
            bedTime: result.$1!,
            wakeTime: result.$2!,
            idealBedTime: result.$3,
            idealWakeTime: result.$4,
          );
    }
  }

  Future<void> _showCompletionDialog(BuildContext context, DailyLog log) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ルーティン完了'),
        content: const Text('朝のルーティンを完了状態にしますか？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('キャンセル')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('完了')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(routineProvider.notifier).completeMorningRoutine(log);
    }
  }
}

class _SleepTimeDialog extends StatefulWidget {
  final DateTime? initialBedTime;
  final DateTime? initialWakeTime;
  final TimeOfDay? initialIdealBedTime;
  final TimeOfDay? initialIdealWakeTime;

  const _SleepTimeDialog({
    this.initialBedTime,
    this.initialWakeTime,
    this.initialIdealBedTime,
    this.initialIdealWakeTime,
  });

  @override
  State<_SleepTimeDialog> createState() => _SleepTimeDialogState();
}

class _SleepTimeDialogState extends State<_SleepTimeDialog> {
  DateTime? bedTime;
  DateTime? wakeTime;
  TimeOfDay? idealBedTime;
  TimeOfDay? idealWakeTime;

  @override
  void initState() {
    super.initState();
    bedTime = widget.initialBedTime;
    wakeTime = widget.initialWakeTime;
    idealBedTime = widget.initialIdealBedTime;
    idealWakeTime = widget.initialIdealWakeTime;
  }

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
                  final now = DateTime.now();
                  final tempBed = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                  
                  // 起床時間と比較して、就寝の方が遅い（23時寝、7時起きなど）場合は前日とする
                  if (wakeTime != null) {
                    // 時刻部分だけを比較したいので、一旦同じ日のDateTimeで比較
                    final baseWake = DateTime(tempBed.year, tempBed.month, tempBed.day, wakeTime!.hour, wakeTime!.minute);
                    if (tempBed.isAfter(baseWake)) {
                      bedTime = tempBed.subtract(const Duration(days: 1));
                    } else {
                      bedTime = tempBed;
                    }
                  } else {
                    // 起床時間が未設定なら、5時以降は前日、それより前は当日深夜とみなす
                    if (picked.hour >= 5) {
                      bedTime = tempBed.subtract(const Duration(days: 1));
                    } else {
                      bedTime = tempBed;
                    }
                  }
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
                  final now = DateTime.now();
                  final tempWake = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                  wakeTime = tempWake;
                  
                  // 起床時間を決めたら、それに合わせて就寝時間の日付も再調整する
                  if (bedTime != null) {
                    final baseBed = DateTime(tempWake.year, tempWake.month, tempWake.day, bedTime!.hour, bedTime!.minute);
                    if (baseBed.isAfter(tempWake)) {
                      bedTime = baseBed.subtract(const Duration(days: 1));
                    } else {
                      bedTime = baseBed;
                    }
                  }
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
