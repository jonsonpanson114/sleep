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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
                      title: Text(task.title),
                      leading: const Icon(Icons.drag_handle),
                      // チェックボックスを追加
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // チェックボックス
                          todayLogAsync.when(
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                            data: (log) {
                              if (log == null) return const SizedBox.shrink();
                              final isCompleted = log!.completedTaskIds.contains(task.id);
                              return Checkbox(
                                value: isCompleted,
                                onChanged: (value) async {
                                  if (value == null) return;
                                  await ref.read(routineProvider.notifier).toggleTask(task.id, log!);
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          // 削除ボタン
                          IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.danger),
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
              child: Row(
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
                        );
                        ref.read(routineProvider.notifier).addTask(task);
                        _textController.clear();
                      }
                    },
                    icon: const Icon(Icons.add),
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
