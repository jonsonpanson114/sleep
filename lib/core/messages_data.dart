/// 時間帯メッセージ定義
class MessagesData {
  static const morningGreeting = 'おはよう。今日も生きてるか？';
  static const afternoonGreeting = 'お疲れ。昼飯は食ったか？';
  static const eveningGreeting = 'こんばんは。夕暮れってのは、どことなく感傷的になるよな。';
  static const nightGreeting = 'まだ起きてるのか。夜はこれからだと言いたいが、寝ろよ。';

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
  static const oneHourUntilBedtime = 'あと1時間半か。そろそろルーティンでも始めたらどうだ？';
  static const perfectBedtime = 'ちょうどいい時間だ。さっさと寝ちまえ。おやすみ。';
  static const afterBedtime = 'おいおい、寝る時間を過ぎてるぞ。今からでも遅くない、布団に入れ。';

  // 起床後
  static const goodSleepPraise = '昨夜はちゃんと寝たみたいだな。奇跡か？朝の儀式を始めようぜ。';

  // 午後のコンディション入力促し
  static const checkCondition = '今日の調子はどうだ？イライラしてないか？';

  // ルーティン未着手
  static const startRoutineReminder = 'そろそろ夜の儀式の時間じゃないか？準備しろよ。';
  static const bedtimeReached = '予定通りの時間だ。お前、真面目だな。寝ろ。';
  static const bedtimeOverdue = '時間を守るのが人生のすべてじゃないが、寝不足は敵だぞ。';

  // 週レポート
  static const improvementMessage = '先週よりやるじゃないか。このまま行けば、何かいいことがあるかもな。';
  static const perfectWeek = '最高の1週間だったな。お前、実は超人なんじゃないか？';
  static const noNap = '昼寝しなかったのか。たまには昼寝も悪くないがな。';
  static const suggestion = '来週は、もう少し早めに布団に入るってのはどうだ？強制はしないがな。';
}
