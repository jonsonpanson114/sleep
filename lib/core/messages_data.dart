/// 時間帯メッセージ定義
class MessagesData {
  static const morningGreeting = 'おはようございます';
  static const afternoonGreeting = 'こんにちは';
  static const eveningGreeting = 'こんばんは';
  static const nightGreeting = 'おやすみなさい';

  static String getGreetingForHour(int hour) {
    if (hour < 12) return morningGreeting;
    if (hour < 18) return afternoonGreeting;
    if (hour < 21) return eveningGreeting;
    return nightGreeting;
  }
}

/// 条件付きメッセージ定義（動的メッセージ用）
class ContextualMessages {
  // 就寝前リマインダー
  static const oneHourUntilBedtime = 'あと1時間半。そろそろ始めませんか？';
  static const perfectBedtime = '完璧なタイミング。おやすみなさい 🌙';
  static const afterBedtime = '今からでも大丈夫。布団に入ろう';

  // 起床後
  static const goodSleepPraise = '昨夜ちゃんと寝れましたね！朝ルーティン始めましょう';

  // 午後のコンディション入力促し
  static const checkCondition = '今日の調子はどうですか？';

  // ルーティン未着手
  static const startRoutineReminder = 'あと1時間半。そろそろ始めませんか？';
  static const bedtimeReached = '完璧なタイミング。おやすみなさい 🌙';
  static const bedtimeOverdue = '今からでも大丈夫。布団に入ろう';

  // 週レポート
  static const improvementMessage = '先週より達成率が向上しました！素晴らしい👍';
  static const perfectWeek = 'イライラも眠気も少なく、充実した1週間でした！';
  static const noNap = '昼寝せずに元気に過ごせましたね';
  static const suggestion = '来週はもう少し就寝を早めに目指してみませんか？';
}
