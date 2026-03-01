import 'package:flutter/material.dart' show TimeOfDay;

class AppSettings {
  final TimeOfDay bedtime;
  final TimeOfDay wakeTime;
  final bool bedtimeNotificationEnabled;
  final bool wakeNotificationEnabled;
  final int bedtimeReminderOffsetMinutes;

  const AppSettings({
    required this.bedtime,
    required this.wakeTime,
    this.bedtimeNotificationEnabled = true,
    this.wakeNotificationEnabled = true,
    this.bedtimeReminderOffsetMinutes = 30,
  });

  AppSettings copyWith({
    TimeOfDay? bedtime,
    TimeOfDay? wakeTime,
    bool? bedtimeNotificationEnabled,
    bool? wakeNotificationEnabled,
    int? bedtimeReminderOffsetMinutes,
  }) {
    return AppSettings(
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      bedtimeNotificationEnabled:
          bedtimeNotificationEnabled ?? this.bedtimeNotificationEnabled,
      wakeNotificationEnabled:
          wakeNotificationEnabled ?? this.wakeNotificationEnabled,
      bedtimeReminderOffsetMinutes:
          bedtimeReminderOffsetMinutes ?? this.bedtimeReminderOffsetMinutes,
    );
  }
}
