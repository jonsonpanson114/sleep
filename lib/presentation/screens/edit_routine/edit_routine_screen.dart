import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/routine_task.dart';
import '../../../core/constants.dart';
import '../../providers/routine_provider.dart';
import '../../widgets/task_tile.dart';

class EditRoutineScreen extends ConsumerWidget {
  final String routineType; // 'evening' | 'morning'

  const EditRoutineScreen({
    super.key,
    required this.routineType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEvening = routineType == 'evening';
    final tasksAsync = ref.watch(routineTasksProvider(isEvening ? RoutineType.evening : RoutineType.morning));

    return Scaffold(
      appBar: AppBar(
        title: Text(isEvening ? '就寝ルーティンを編集' : '朝ルーティンを編集'),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
                child: Text('エラー: $err'),
              ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.playlist_add, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'タスクがありません',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: '新しいタスクを入力してください',
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        final uuid = DateTime.now().millisecond.toString();
                        ref.read(routineProvider.notifier).addTask(
                          RoutineTask(
                            id: uuid,
                            title: value.trim(),
                            type: isEvening ? RoutineType.evening : RoutineType.morning,
                            sortOrder: tasks.length,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }

          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (oldIndex != newIndex) {
                final reorderedTasks = List<RoutineTask>.from(tasks);
                final movedTask = reorderedTasks.removeAt(oldIndex);
                reorderedTasks.insert(newIndex, movedTask);
                // sortOrderを更新
                for (var i = 0; i < reorderedTasks.length; i++) {
                  reorderedTasks[i] =
                      reorderedTasks[i].copyWith(sortOrder: i);
                }
                ref.read(routineProvider.notifier).reorderTasks(
                    isEvening ? RoutineType.evening : RoutineType.morning,
                    reorderedTasks,
                  );
              }
            },
            children: [
              for (final task in tasks)
                TaskTile(
                  task: task,
                  isCompleted: false,
                  onTap: () {},
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('削除しますか？'),
                                content: const Text('このタスクを削除します。よろしいですか？'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('キャンセル'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.danger,
                                    ),
                                    child: const Text('削除'),
                                  ),
                                ],
                              ),
                        );
                    if (confirmed == true) {
                      ref.read(routineProvider.notifier).deleteTask(task.id);
                    }
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
