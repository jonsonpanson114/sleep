import 'dart:typed_data';
import 'dart:js' as js; // Web版でバイブを叩くため
import 'package:flutter/foundation.dart' show kIsWeb;
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
    // Web(PWA含む)の場合は標準の通知許可リクエストのみ試行
    if (kIsWeb) {
      // PWAでの通知は将来的な拡張のために構造だけ残す
      return;
    }
    
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
    // 東京固定をやめて、ローカルを取得
    final String timeZoneName = tz.local.name;
    tz.setLocalLocation(tz.getLocation(timeZoneName));

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
    if (kIsWeb) return;
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

    // バイブレーションパターンの設定（就寝前：控えめ）
    final Int64List vibrationPattern = Int64List.fromList([0, 500]); // 0.5秒だけ震える

    await _plugin.zonedSchedule(
      NotificationIds.bedtimeReminder,
      'そろそろ就寝の時間です',
      '今から布団に入りましょう 🌙',
      tzScheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'bedtime_channel',
          '就寝リマインダー',
          icon: '@mipmap/ic_launcher',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          vibrationPattern: vibrationPattern,
          enableVibration: true,
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
    if (kIsWeb) return;
    if (!_initialized) await init();

    final now = DateTime.now();
    var alarmTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    // すで過ぎていれば明日にスケジュール
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    final tzAlarmTime = tz.TZDateTime.from(alarmTime, tz.local);

    // バイブレーションパターンの設定（起床：しっかり）
    final Int64List vibrationPattern = Int64List.fromList([0, 1000, 500, 1000, 500, 1000]); // 震える・休む・震える

    await _plugin.zonedSchedule(
      NotificationIds.wakeAlarm,
      'おはようございます！',
      '起床ルーティンを始めましょう ☀️',
      tzAlarmTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'wake_channel',
          '起床アラーム',
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          vibrationPattern: vibrationPattern,
          enableVibration: true,
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
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  /// 設定に応じて全通知を再スケジュール
  static Future<void> rescheduleAll(AppSettings settings) async {
    // Web版(PWA)の場合はバックグラウンド通知が難しいため、
    // ここではネイティブアプリ版のみ処理する
    if (kIsWeb) return;

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

  /// 即時テスト通知を送信
  static Future<void> testNotification() async {
    // Web版(PWA)の場合はブラウザのAPIを使用
    if (kIsWeb) {
      js.context.callMethod('eval', ["""
        (function() {
          console.log('--- Ultimate Notification Audit Start ---');
          var log = function(m) { console.log('[Audit] ' + m); };
          var errorReport = [];

          // 1. Vibrate Test
          try {
            if (navigator && navigator.vibrate) {
              log('Attempting vibrate...');
              navigator.vibrate([200, 100, 200]);
            } else {
              log('navigator.vibrate not supported');
            }
          } catch (e) {
            errorReport.push('Vibrate Error: ' + e.message);
          }

          // 2. Notification Audit
          try {
            if (typeof window !== 'undefined' && !('Notification' in window)) {
              errorReport.push('Global Notification object not found (might be iOS)');
            } else {
              log('Current permission: ' + Notification.permission);
              
              var showTestNotification = function() {
                try {
                  var options = { 
                    body: 'この通知が見えてれば信号は届いてる。',
                    icon: '/icons/Icon-192.png',
                    vibrate: [200, 100, 200],
                    tag: 'test-notification'
                  };
                  if (navigator && navigator.serviceWorker && navigator.serviceWorker.controller) {
                    log('Using ServiceWorkerRegistration...');
                    navigator.serviceWorker.ready.then(function(reg) {
                      reg.showNotification('テスト通知完了！', options).catch(function(e) {
                        log('SW Error: ' + e);
                        new Notification('テスト通知完了！', options);
                      });
                    });
                  } else {
                    log('Falling back to new Notification...');
                    new Notification('テスト通知完了！', options);
                  }
                } catch (e) {
                  errorReport.push('Notification Exception: ' + e.message);
                }
              };

              if (Notification.permission === 'granted') {
                showTestNotification();
              } else if (Notification.permission !== 'denied') {
                log('Requesting permission...');
                try {
                  var promise = Notification.requestPermission(function(p) {
                    log('Callback permission: ' + p);
                    if (p === 'granted') showTestNotification();
                  });
                  if (promise && promise.then) {
                    promise.then(function(p) {
                      log('Promise permission: ' + p);
                      if (p === 'granted') showTestNotification();
                    });
                  }
                } catch (e) {
                  errorReport.push('Permission Request Error: ' + e.message);
                }
              }
            }
          } catch (e) {
            errorReport.push('General Notification Error: ' + e.message);
          }

          if (errorReport.length > 0) {
            var msg = 'AUDIT FAILED:\\n' + errorReport.join('\\n');
            console.warn(msg);
          }
          log('Build: 2026-03-18 22:45 (Final Brute Force Fix)');
          log('--- Ultimate Notification Audit End ---');
        })();
      """]);
      return;
    }

    if (!_initialized) await init();

    await _plugin.show(
      999,
      'テスト通知だぜ',
      'バイブレーションは感じたか？うまく動いてるみたいだな。',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'テスト通知',
          importance: Importance.max,
          priority: Priority.high,
          vibrationPattern: Int64List.fromList([0, 500, 100, 500]),
          enableVibration: true,
        ),
      ),
    );
  }
}
