import 'package:flutter/material.dart' show TimeOfDay;
import '../entities/daily_log.dart';
import '../../core/messages_data.dart';

enum MessageType { praise, encouragement, gentleReminder, normal }

class ContextMessage {
  final MessageType type;
  final String text;

  ContextMessage({
    required this.type,
    required this.text,
  });
}

class GetContextualMessage {
  ContextMessage execute({
    required DateTime now,
    required TimeOfDay bedtime,
    required TimeOfDay wakeTime,
    required DailyLog? todayLog,
  }) {
    final hour = now.hour;
    final minutesUntilBedtime =
        (bedtime.hour * 60 + bedtime.minute) - (hour * 60 + now.minute);

    // ルーティン未着手時
    if (todayLog != null && !todayLog.eveningCompleted) {
      if (minutesUntilBedtime > 0 && minutesUntilBedtime <= 90) {
        return ContextMessage(
          type: MessageType.gentleReminder,
          text: ContextualMessages.startRoutineReminder,
        );
      }
      if (hour == bedtime.hour) {
        return ContextMessage(
          type: MessageType.encouragement,
          text: ContextualMessages.perfectBedtime,
        );
      }
    }

    // 就寝時刻超過
    if (hour > bedtime.hour) {
      return ContextMessage(
        type: MessageType.gentleReminder,
        text: ContextualMessages.bedtimeOverdue,
      );
    }

    // 起床直後
    if (hour == wakeTime.hour) {
      if (todayLog?.morningCompleted == true) {
        return ContextMessage(
          type: MessageType.praise,
          text: ContextualMessages.goodSleepPraise,
        );
      }
    }

    // 午後のコンディション入力促し
    if (hour == 15 && todayLog?.napTaken == null) {
      return ContextMessage(
        type: MessageType.gentleReminder,
        text: ContextualMessages.checkCondition,
      );
    }

    // デフォルトメッセージ（時間帯）
    if (hour < 12) {
      return ContextMessage(
        type: MessageType.normal,
        text: '${MessagesData.morningGreeting} ☀️',
      );
    }
    if (hour < 18) {
      return ContextMessage(
        type: MessageType.normal,
        text: '${MessagesData.afternoonGreeting} ☕',
      );
    }
    if (hour < 21) {
      return ContextMessage(
        type: MessageType.normal,
        text: '${MessagesData.eveningGreeting} 🌆',
      );
    }
    return ContextMessage(
      type: MessageType.normal,
      text: '${MessagesData.nightGreeting} 🌙',
    );
  }
}
