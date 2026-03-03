import 'package:flutter/material.dart';
import '../../../domain/entities/routine_task.dart';
import '../../../core/constants.dart';

class TaskTile extends StatelessWidget {
  final RoutineTask task;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.isCompleted,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isCompleted,
      title: Text(
        task.title,
        style: TextStyle(
          color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      onChanged: (value) => onTap?.call(),
      activeColor: AppColors.success,
      checkColor: Colors.white,
      secondary: onDelete != null
          ? IconButton(
              icon: Icon(Icons.delete, color: AppColors.danger),
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
            )
          : null,
    );
  }
}
