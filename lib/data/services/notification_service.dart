import 'dart:typed_data';
import 'dart:js' as js;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:http/http.dart' as http;
import '../../domain/entities/app_settings.dart';
import '../../core/constants.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  static const String _vapidPublicKey = 'BP9qUkCWWuVTJDNZWknPNWsITyccSF_2Zl_VHdqz8vujtH8he7AFZKGeAU9PBl7TWj3J-Rvvdpfw_E5Sq4UqXOk'; // 生成済みの特製VAPID

  /// 現在の通知許可状態を取得
  static Future<String> getPermissionStatus() async {
    if (!kIsWeb) return 'granted';
    try {
      return js.context.callMethod('eval', ['Notification.permission']) as String;
    } catch (e) {
      return 'unsupported';
    }
  }

  /// 初期化・権限リクエスト
  static Future<void> init() async {
    if (_initialized) return;

    if (kIsWeb) {
      // Webの場合、ブラウザに通知許可を求める
      try {
        js.context.callMethod('eval', ["""
          if ('Notification' in window && Notification.permission !== 'granted' && Notification.permission !== 'denied') {
            Notification.requestPermission();
          }
        """]);
      } catch (e) {
        debugPrint('Web Push permission init error: $e');
      }
      _initialized = true;
      return;
    }

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
    final String timeZoneName = tz.local.name;
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  /// 就寝リマインダーをスケジュール（ネイティブ専用）
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

    var scheduledTime = reminderTime;
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
    final Int64List vibrationPattern = Int64List.fromList([0, 500]);

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

  /// 起床アラームをスケジュール（ネイティブ専用）
  static Future<void> scheduleWakeAlarm(TimeOfDay time) async {
    if (kIsWeb) return;
    if (!_initialized) await init();

    final now = DateTime.now();
    var alarmTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    final tzAlarmTime = tz.TZDateTime.from(alarmTime, tz.local);
    final Int64List vibrationPattern = Int64List.fromList([0, 1000, 500, 1000, 500, 1000]); 

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

  static Future<void> cancelBedtimeReminder() async {
    if (kIsWeb) return;
    await _plugin.cancel(NotificationIds.bedtimeReminder);
  }

  static Future<void> cancelWakeAlarm() async {
    if (kIsWeb) return;
    await _plugin.cancel(NotificationIds.wakeAlarm);
  }

  static Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  /// PWA向け 本気のWeb Push サーバー連携 (Vercel -> GASエコシステムへ登録)
  static Future<void> _syncWebPushSettings(AppSettings settings) async {
    try {
      // index.htmlに仕掛けたsubscribeToPushを呼び出してTokenを取得
      // 非同期関数の結果を受け取るには Promise から解決させる必要があるが、
      // 簡易的にJS内で結果を変数に格納し、Dartから読む方法などを取るか、
      // あるいは直接Dart APIを使用する(package:js)。今回は原始的なPromise待機を使用。
      // wait for Promise:
      final rawSub = await js.context.callMethod('subscribeToPush', [_vapidPublicKey]);
      
      // Returns a Promise<string | null> under the hood in Dart when using callMethod asynchronously? 
      // Actually `callMethod` doesn't await Promise properly unless it's a Future from dart:js_util.
      // 代替策: JS側で fetch する方が確実。
      // ここでは、Dart側で直接fetchを叩かせるため、JSに `window.subscribeToPushInfo` を叩かせた後、
      // 取得した文字列（JSON）をPOSTする形をとるか。
      // ...が、簡略化のため、JS内で `/api/push-subscription` へfetchする関数を呼び出させよう。
    } catch (e) {
      debugPrint('Web Push sync error: $e');
    }
  }

  /// 設定に応じて全通知を再スケジュール（またはサーバーへ同期）
  static Future<void> rescheduleAll(AppSettings settings) async {
    if (kIsWeb) {
      // PWA(Web版): Vercel Serverless へ通知設定と購読情報を同期する
      _syncToServerlessWebPush(settings);
      return;
    }

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

  /// JSから購読オブジェクトを拾い出して、DartのhttpでVercelへ投げる
  static Future<void> _syncToServerlessWebPush(AppSettings settings) async {
    try {
      // Dart<=>JSの非同期処理の壁を越えるため、JS内で全部処理させてしまうのが最も安全で早い
      final settingsJson = jsonEncode({
        'bedtimeHour': settings.bedtime.hour,
        'bedtimeMinute': settings.bedtime.minute,
        'wakeHour': settings.wakeTime.hour,
        'wakeMinute': settings.wakeTime.minute,
        'bedtimeEnabled': settings.bedtimeNotificationEnabled,
        'wakeEnabled': settings.wakeNotificationEnabled,
        'offset': settings.bedtimeReminderOffsetMinutes,
      });

      js.context.callMethod('eval', ["""
        (async function() {
          try {
            if (typeof window.subscribeToPush !== 'function') {
              console.warn("subscribeToPush is missing");
              return;
            }
            if (Notification.permission !== 'granted') {
              const p = await Notification.requestPermission();
              if (p !== 'granted') return;
            }
            const subStr = await window.subscribeToPush('$_vapidPublicKey');
            if (subStr) {
              const subJson = JSON.parse(subStr);
              const settingsData = $settingsJson;
              
              const res = await fetch('/api/push-subscription', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                  subscription: subJson,
                  settings: settingsData
                })
              });
              const resultText = await res.text();
              console.log('Web Push Sync Result:', resultText);
            }
          } catch(e) {
            console.error('Final sync block error:', e);
          }
        })();
      """]);
    } catch (e) {
      debugPrint('Dart syncToServerlessWebPush error: $e');
    }
  }

  /// テスト通知を送信
  static Future<void> testNotification() async {
    if (kIsWeb) {
      js.context.callMethod('eval', ["""
        (async function() {
          if (Notification.permission === 'granted' && navigator.serviceWorker) {
            const reg = await navigator.serviceWorker.ready;
            reg.showNotification('テスト通知成功！', {
              body: '新アイコンもいい感じだろ！バイブレーションも設定済みだ。',
              icon: '/icons/notification_stylish.png',
              vibrate: [200, 100, 200]
            });
          } else {
            console.warn('通知許可がないか、Service Workerが準備できていません');
          }
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
