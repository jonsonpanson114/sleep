import 'package:flutter/material.dart' show TimeOfDay;

class WeeklyReport {
  final DateTime weekStart;
  final DateTime weekEnd;
  final double completionRate;
  final double? previousWeekRate;
  final TimeOfDay averageBedtime;
  final TimeOfDay averageWakeTime;
  final int currentStreak;
  final int maxStreak;
  final int napDays;
  final int sleepinessDays;
  final int irritableDays;
  final String insightMessage;

  const WeeklyReport({
    required this.weekStart,
    required this.weekEnd,
    required this.completionRate,
    required this.previousWeekRate,
    required this.averageBedtime,
    required this.averageWakeTime,
    required this.currentStreak,
    required this.maxStreak,
    required this.napDays,
    required this.sleepinessDays,
    required this.irritableDays,
    required this.insightMessage,
  });
}
