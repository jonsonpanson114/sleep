import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../../domain/entities/app_settings.dart';
import '../../core/constants.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// 初期化・権限リクエスト
  static Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

    // Android 13+ で通知権限をリクエスト
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  /// 就寝リマインダーをスケジュール
  static Future<void> scheduleBedtimeReminder(
    TimeOfDay time,
    int offsetMinutes,
  ) async {
    if (!_initialized) await init();

    final now = DateTime.now();
    final reminderTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).subtract(Duration(minutes: offsetMinutes));

    // すで過ぎていれば明日にスケジュール
    var scheduledTime = reminderTime;
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
    final scheduledDay = scheduledTime.weekday;

    // 日曜日にはリマインダーを送らない（週レポートに任せるため）
    if (scheduledDay == DateTime.sunday) {
      return;
    }

    await _plugin.zonedSchedule(
      NotificationIds.bedtimeReminder,
      'そろそろ就寝の時間です',
      '今から布団に入りましょう 🌙',
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bedtime_channel',
          '就寝リマインダー',
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// 起床アラームをスケジュール
  static Future<void> scheduleWakeAlarm(TimeOfDay time) async {
    if (!_initialized) await init();

    final now = DateTime.now();
    var alarmTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    // すで過ぎていれば明日にスケジュール
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    final tzAlarmTime = tz.TZDateTime.from(alarmTime, tz.local);

    await _plugin.zonedSchedule(
      NotificationIds.wakeAlarm,
      'おはようございます！',
      '起床ルーティンを始めましょう ☀️',
      tzAlarmTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'wake_channel',
          '起床アラーム',
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// 就寝リマインダーをキャンセル
  static Future<void> cancelBedtimeReminder() async {
    await _plugin.cancel(NotificationIds.bedtimeReminder);
  }

  /// 起床アラームをキャンセル
  static Future<void> cancelWakeAlarm() async {
    await _plugin.cancel(NotificationIds.wakeAlarm);
  }

  /// 全通知をキャンセル
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// 設定に応じて全通知を再スケジュール
  static Future<void> rescheduleAll(AppSettings settings) async {
    await cancelAll();

    if (settings.bedtimeNotificationEnabled) {
      await scheduleBedtimeReminder(
        settings.bedtime,
        settings.bedtimeReminderOffsetMinutes,
      );
    }

    if (settings.wakeNotificationEnabled) {
      await scheduleWakeAlarm(settings.wakeTime);
    }
  }
}
