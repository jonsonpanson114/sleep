import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/routine_task.dart';
import '../../../core/constants.dart';
import '../../providers/routine_provider.dart';

class EditRoutineScreen extends ConsumerStatefulWidget {
  final RoutineType type;
  const EditRoutineScreen({super.key, required this.type});

  @override
  ConsumerState<EditRoutineScreen> createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends ConsumerState<EditRoutineScreen> {
  final _textController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(routineTasksProvider(widget.type));
    final todayLogAsync = ref.watch(todayLogProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == RoutineType.morning ? '朝ルーティンの編集' : '夜ルーティンの編集'),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('エラー: $err')),
        data: (tasks) => Column(
          children: [
            Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.all(16),
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final items = List<RoutineTask>.from(tasks);
                  final item = items.removeAt(oldIndex);
                  items.insert(newIndex, item);
                  ref.read(routineProvider.notifier).reorderTasks(widget.type, items);
                },
                children: [
                  for (final task in tasks)
                    ListTile(
                      key: ValueKey(task.id),
                      leading: const Icon(Icons.drag_handle),
                      title: Text(task.title),
                      subtitle: (task.startTime != null || task.endTime != null)
                          ? Text(
                              '${task.startTime ?? '--:--'} - ${task.endTime ?? '--:--'}',
                              style: const TextStyle(fontSize: 12),
                            )
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 時間編集ボタン
                          IconButton(
                            icon: const Icon(Icons.access_time, size: 20),
                            onPressed: () async {
                              TimeOfDay? parseTime(String? s) {
                                if (s == null || !s.contains(':')) return null;
                                final parts = s.split(':');
                                return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                              }

                              final currentStart = parseTime(task.startTime);
                              final start = await showTimePicker(
                                context: context,
                                initialTime: currentStart ?? TimeOfDay.now(),
                                helpText: '開始時間を選択',
                              );
                              if (start == null) return;

                              if (!mounted) return;
                              final currentEnd = parseTime(task.endTime);
                              final end = await showTimePicker(
                                context: context,
                                initialTime: currentEnd ?? start,
                                helpText: '終了時間を選択',
                              );
                              if (end == null) return;

                              ref.read(routineProvider.notifier).updateTask(task.copyWith(
                                    startTime: _formatTime(start),
                                    endTime: _formatTime(end),
                                  ));
                            },
                          ),
                          // チェックボックス
                          todayLogAsync.when(
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                            data: (log) {
                              if (log == null) return const SizedBox.shrink();
                              final isCompleted = log.completedTaskIds.contains(task.id);
                              return Checkbox(
                                value: isCompleted,
                                onChanged: (value) async {
                                  if (value == null) return;
                                  await ref.read(routineProvider.notifier).toggleTask(task.id);
                                },
                              );
                            },
                          ),
                          // 削除ボタン
                          IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.danger, size: 20),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('削除してよろしいですか？'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('キャンセル'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('削除', style: TextStyle(color: AppColors.danger)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                ref.read(routineProvider.notifier).deleteTask(task.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: '新しいタスクを追加',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filled(
                        onPressed: () {
                          if (_textController.text.trim().isNotEmpty) {
                            final task = RoutineTask(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              title: _textController.text.trim(),
                              type: widget.type,
                              sortOrder: tasks.length,
                              startTime: _startTime != null ? _formatTime(_startTime) : null,
                              endTime: _endTime != null ? _formatTime(_endTime) : null,
                            );
                            ref.read(routineProvider.notifier).addTask(task);
                            _textController.clear();
                            setState(() {
                              _startTime = null;
                              _endTime = null;
                            });
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.access_time, size: 16),
                        label: Text('開始: ${_formatTime(_startTime)}'),
                        onPressed: () => _selectTime(context, true),
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        avatar: const Icon(Icons.access_time, size: 16),
                        label: Text('終了: ${_formatTime(_endTime)}'),
                        onPressed: () => _selectTime(context, false),
                      ),
                      const Spacer(),
                      if (_startTime != null || _endTime != null)
                        TextButton(
                          onPressed: () => setState(() {
                            _startTime = null;
                            _endTime = null;
                          }),
                          child: const Text('クリア'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
