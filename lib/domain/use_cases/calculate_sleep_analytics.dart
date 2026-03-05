import '../entities/daily_log.dart';
import '../../domain/entities/app_settings.dart';
import 'package:flutter/material.dart' show TimeOfDay;

class SleepAnalyticsResult {
  final TimeOfDay? bestBedtime;
  final TimeOfDay? bestWakeTime;
  final double fatigueLevel; // 0.0 - 1.0
  final bool suggestEarlySleep;
  final String insightMessage;

  SleepAnalyticsResult({
    this.bestBedtime,
    this.bestWakeTime,
    required this.fatigueLevel,
    required this.suggestEarlySleep,
    required this.insightMessage,
  });
}

class CalculateSleepAnalytics {
  SleepAnalyticsResult execute({
    required List<DailyLog> logs,
    required AppSettings currentSettings,
  }) {
    if (logs.isEmpty) {
      return SleepAnalyticsResult(
        fatigueLevel: 0.1,
        suggestEarlySleep: false,
        insightMessage: 'データが溜まれば、あなたに最適な睡眠時間を分析します。',
      );
    }

    // 1. 疲れ度推定 (直近3日のルーティン未達 & コンディション悪化)
    final recent3 = logs.take(3).toList();
    double fatigue = 0.0;
    if (recent3.isNotEmpty) {
      // ルーティン未達
      final missingCount = recent3.where((l) => !l.eveningCompleted || !l.morningCompleted).length;
      fatigue += (missingCount / 3.0) * 0.5;
      // 眠気・イライラ
      final badFeelCount = recent3.where((l) => l.daytimeSleepiness == true || l.feltIrritable == true).length;
      fatigue += (badFeelCount / 3.0) * 0.5;
    }
    final suggestEarly = fatigue >= 0.6;

    // 2. ベストタイム検出 (コンディションが良い日の時間を探す)
    final goodDays = logs.where((l) => 
      l.daytimeSleepiness == false && 
      l.feltIrritable == false && 
      l.eveningCompleted && 
      l.morningCompleted
    ).toList();

    TimeOfDay? bestBed;
    TimeOfDay? bestWake;

    if (goodDays.isNotEmpty) {
      // コンディションが良い日の実測値の平均を取る（簡易版）
      int totalBedMinutes = 0;
      int totalWakeMinutes = 0;
      int count = 0;

      for (final l in goodDays) {
        if (l.bedTime != null && l.wakeTime != null) {
          totalBedMinutes += l.bedTime!.hour * 60 + l.bedTime!.minute;
          totalWakeMinutes += l.wakeTime!.hour * 60 + l.wakeTime!.minute;
          count++;
        }
      }

      if (count > 0) {
        final avgBed = totalBedMinutes ~/ count;
        final avgWake = totalWakeMinutes ~/ count;
        bestBed = TimeOfDay(hour: (avgBed ~/ 60) % 24, minute: avgBed % 60);
        bestWake = TimeOfDay(hour: (avgWake ~/ 60) % 24, minute: avgWake % 60);
      } else {
        bestBed = currentSettings.bedtime;
        bestWake = currentSettings.wakeTime;
      }
    }

    String message = fatigue > 0.4 ? '最近、少し疲れが溜まっていませんか？ 無理は禁物です。' : '順調なリズムですね。この調子でいきましょう。';
    if (suggestEarly) {
      message = '今日は早めに寝ることを推奨します。ルーティンを最小限にして体を休めましょう。';
    }

    return SleepAnalyticsResult(
      bestBedtime: bestBed,
      bestWakeTime: bestWake,
      fatigueLevel: fatigue.clamp(0.0, 1.0),
      suggestEarlySleep: suggestEarly,
      insightMessage: message,
    );
  }
}
