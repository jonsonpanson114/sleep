import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../database/app_database.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final AppDatabase db;

  SettingsRepositoryImpl() : db = AppDatabase() {
    db.seedDefaultData();
  }

  @override
  Future<AppSettings?> getSettings() async {
    final settings = await db.select(db.settingsTable).getSingleOrNull();
    if (settings == null) return null;

    return AppSettings(
      bedtime: TimeOfDay(hour: settings.bedtimeHour, minute: settings.bedtimeMinute),
      wakeTime: TimeOfDay(hour: settings.wakeHour, minute: settings.wakeMinute),
      bedtimeNotificationEnabled: settings.bedtimeNotifEnabled,
      wakeNotificationEnabled: settings.wakeNotifEnabled,
      bedtimeReminderOffsetMinutes: settings.reminderOffsetMinutes,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final existing = await db.select(db.settingsTable).getSingleOrNull();

    if (existing == null) {
      await db.into(db.settingsTable).insert(SettingsTableCompanion.insert(
            bedtimeHour: settings.bedtime.hour,
            bedtimeMinute: settings.bedtime.minute,
            wakeHour: settings.wakeTime.hour,
            wakeMinute: settings.wakeTime.minute,
            bedtimeNotifEnabled: Value(settings.bedtimeNotificationEnabled),
            wakeNotifEnabled: Value(settings.wakeNotificationEnabled),
            reminderOffsetMinutes: Value(settings.bedtimeReminderOffsetMinutes),
          ));
    } else {
      await (db.update(db.settingsTable)
            ..where((s) => s.id.equals(existing.id)))
          .write(SettingsTableCompanion(
        bedtimeHour: Value(settings.bedtime.hour),
        bedtimeMinute: Value(settings.bedtime.minute),
        wakeHour: Value(settings.wakeTime.hour),
        wakeMinute: Value(settings.wakeTime.minute),
        bedtimeNotifEnabled: Value(settings.bedtimeNotificationEnabled),
        wakeNotifEnabled: Value(settings.wakeNotificationEnabled),
        reminderOffsetMinutes: Value(settings.bedtimeReminderOffsetMinutes),
      ));
    }
  }
}
