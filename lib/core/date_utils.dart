import 'package:flutter/material.dart' show TimeOfDay;
import 'package:intl/intl.dart';

/// 日付関連のユーティリティ
class DateUtils {
  /// 今日の日付キーを取得 (YYYY-MM-DD形式)
  static String get todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// 指定された日数前の日付キーを取得
  static String dateKeyFromDaysAgo(int days) {
    final date = DateTime.now().subtract(Duration(days: days));
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// 週の開始日（日曜日）を取得
  static DateTime startOfWeek(DateTime date) {
    final weekday = date.weekday;  // 1=月, 7=日
    final daysUntilSunday = 7 - weekday;
    return date.subtract(Duration(days: daysUntilSunday % 7));
  }

  /// 週の終了日（土曜日）を取得
  static DateTime endOfWeek(DateTime date) {
    final start = startOfWeek(date);
    return start.add(const Duration(days: 6));
  }

  /// 指定された日が日曜日かどうか
  static bool isSunday(DateTime date) => date.weekday == DateTime.sunday;

  /// 時間をフォーマット (例: "22:30")
  static String formatTime(int hour, int minute) {
    return DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
  }

  /// TimeOfDay を分単位に変換
  static int timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  /// 指定された日時が目標就寝時刻より前かどうか
  static bool isBeforeBedtimeTarget(
    DateTime date,
    TimeOfDay bedtime,
  ) {
    final bedMinutes = timeOfDayToMinutes(bedtime);
    final nowMinutes = date.hour * 60 + date.minute;
    return nowMinutes < bedMinutes;
  }

  /// 指定された日時が目標就寝時刻より後かどうか
  static bool isAfterBedtimeTarget(
    DateTime date,
    TimeOfDay bedtime,
  ) {
    return !isBeforeBedtimeTarget(date, bedtime);
  }

  /// 指定された日時が22:30以前かどうか
  static bool isEarlyBedtime(DateTime date) {
    return date.hour < 22 || (date.hour == 22 && date.minute <= 30);
  }
}
