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
      // 簡易的にコンディションが良い日の平均などを取る (本来は就寝時間の記録が必要だが、今は設定値ベースで推論)
      bestBed = currentSettings.bedtime; // 実測値がDBにあればそれを使うが、今は設定を調整する
      bestWake = currentSettings.wakeTime;
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
