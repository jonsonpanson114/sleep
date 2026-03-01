import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/get_contextual_message.dart';
import 'settings_provider.dart';
import 'routine_provider.dart';

final messageProvider = Provider<ContextMessage>((ref) {
  final settings = ref.watch(settingsProvider);
  final todayLog = ref.watch(todayLogProvider);
  final now = DateTime.now();

  final bedtime = settings.value?.bedtime ?? const TimeOfDay(hour: 22, minute: 30);
  final wakeTime = settings.value?.wakeTime ?? const TimeOfDay(hour: 6, minute: 30);

  final getMessage = GetContextualMessage();
  return getMessage.execute(
    now: now,
    bedtime: bedtime,
    wakeTime: wakeTime,
    todayLog: todayLog.value,
  );
});
