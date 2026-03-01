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
    return ListTile(
      leading: Checkbox(
        value: isCompleted,
        onChanged: (value) => onTap?.call(),
        activeColor: AppColors.success,
        checkColor: Colors.white,
      ),
      title: Text(
        task.title,
        style: TextStyle(
          color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: onDelete != null
          ? IconButton(
              icon: Icon(Icons.delete, color: AppColors.danger),
              onPressed: onDelete,
            )
          : null,
      onTap: onTap,
    );
  }
}
