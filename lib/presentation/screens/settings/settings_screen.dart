import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/time_picker_tile.dart';
import '../../../core/constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('エラー: $err')),
        data: (settings) {
          if (settings == null) {
            return const Center(child: Text('設定を読み込み中...'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 24),
              const Text(
                '就寝・起床時刻',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              TimePickerTile(
                label: '就寝時刻',
                hour: settings.bedtime.hour,
                minute: settings.bedtime.minute,
              ),
              TimePickerTile(
                label: '起床時刻',
                hour: settings.wakeTime.hour,
                minute: settings.wakeTime.minute,
              ),
              const SizedBox(height: 24),
              const Text(
                '通知',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              SwitchListTile(
                title: const Text('就寝リマインダー'),
                subtitle: const Text('30分前に通知'),
                value: settings.bedtimeNotificationEnabled,
                onChanged: (value) =>
                    ref.read(settingsProvider.notifier).toggleBedtimeNotification(value),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('起床アラーム'),
                value: settings.wakeNotificationEnabled,
                onChanged: (value) =>
                    ref.read(settingsProvider.notifier).toggleWakeNotification(value),
              ),
              const SizedBox(height: 32),
              const Text(
                'リマインダー時間',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(
                    value: 15,
                    label: Text('15分'),
                  ),
                  ButtonSegment<int>(
                    value: 30,
                    label: Text('30分'),
                  ),
                  ButtonSegment<int>(
                    value: 60,
                    label: Text('60分'),
                  ),
                ],
                selected: {settings.bedtimeReminderOffsetMinutes},
                onSelectionChanged: (Set<int> values) {
                  ref.read(settingsProvider.notifier).updateReminderOffset(values.first);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
