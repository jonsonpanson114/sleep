import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../providers/settings_provider.dart';

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

  Future<void> _selectTime(BuildContext context, WidgetRef ref, bool isBedtime) async {
    final picked = await showTimePicker(
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

    if (!context.mounted || picked == null) return;

    // Provider経由で更新
    final notifier = ref.read(settingsProvider.notifier);
    if (isBedtime) {
      await notifier.updateBedtime(picked);
    } else {
      await notifier.updateWakeTime(picked);
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
      onTap: () => _selectTime(context, ref, label.contains('就寝')),
    );
  }
}
