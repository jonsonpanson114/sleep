import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';

class TimePickerTile extends ConsumerWidget {
  final String label;
  final int hour;
  final int minute;

  const TimePickerTile({
    super.key,
    required this.label,
    required this.hour,
    required this.minute,
  });

  Future<void> _selectTime(BuildContext context, bool isBedtime) async {
    final _ = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!context.mounted) return;

    // Provider経由で更新
    if (isBedtime) {
      // SettingsNotifier にアクセスする必要がある
      // 実際の画面では直接実装
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: AppColors.textPrimary,
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
      onTap: () => _selectTime(context, label.contains('就寝')),
    );
  }
}
