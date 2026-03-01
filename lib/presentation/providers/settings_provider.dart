import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/notification_service.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import 'repository_providers.dart';

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings?>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<AppSettings?> {
  late SettingsRepository _repo;

  @override
  Future<AppSettings?> build() async {
    _repo = ref.watch(settingsRepositoryProvider);
    return _repo.getSettings();
  }

  Future<void> _reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.getSettings());
  }

  Future<void> updateBedtime(TimeOfDay time) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(bedtime: time);
    await _repo.saveSettings(updated);
    await _reload();
    await NotificationService.rescheduleAll(updated);
  }

  Future<void> updateWakeTime(TimeOfDay time) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(wakeTime: time);
    await _repo.saveSettings(updated);
    await _reload();
    await NotificationService.rescheduleAll(updated);
  }

  Future<void> toggleBedtimeNotification(bool enabled) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(bedtimeNotificationEnabled: enabled);
    await _repo.saveSettings(updated);
    await _reload();
    await NotificationService.rescheduleAll(updated);
  }

  Future<void> toggleWakeNotification(bool enabled) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(wakeNotificationEnabled: enabled);
    await _repo.saveSettings(updated);
    await _reload();
    await NotificationService.rescheduleAll(updated);
  }

  Future<void> updateReminderOffset(int minutes) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(bedtimeReminderOffsetMinutes: minutes);
    await _repo.saveSettings(updated);
    await _reload();
    await NotificationService.rescheduleAll(updated);
  }
}
