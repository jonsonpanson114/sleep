import '../../domain/entities/daily_log.dart';
import '../../domain/entities/weekly_summary.dart';

class WeeklySummarySpecialist {
  static const String specialistName = '斎藤';

  static WeeklySummary generate(List<DailyLog> logs) {
    if (logs.isEmpty) {
      return WeeklySummary(
        dateRange: 'データなし',
        content: '「睡眠っていうのは、真っ白なキャンバスに似ている。まだ何も描かれていないなら、これから何でも描けるってことさ。まずは横になって、目を閉じることから始めてみたらどうだい？」',
        averageSleepQuality: 0,
        routineCompletionRate: 0,
      );
    }

    final totalTasks = logs.length * 2; // evening and morning
    var completedTasks = 0;
    var sleepyCount = 0;
    var irritableCount = 0;

    for (var log in logs) {
      if (log.eveningCompleted) completedTasks++;
      if (log.morningCompleted) completedTasks++;
      if (log.daytimeSleepiness == true) sleepyCount++;
      if (log.feltIrritable == true) irritableCount++;
    }

    final routineRate = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    // quality: fewer sleepy/irritable days = better quality
    final badDayRate = (sleepyCount + irritableCount) / (logs.length * 2.0);
    final quality = (1 - badDayRate).clamp(0.0, 1.0);

    String message = _generateMessage(routineRate, quality);

    return WeeklySummary(
      dateRange: '直近の記録',
      content: message,
      averageSleepQuality: quality,
      routineCompletionRate: routineRate,
    );
  }

  static String _generateMessage(double routineRate, double quality) {
    if (routineRate > 0.8 && quality > 0.8) {
      return '「完璧だ。あんたの眠りは、整備の行き届いたクラシックカーのエンジン音みたいに静かで力強い。世界が明日終わるとしても、あんたならぐっすり眠っていられるだろうね。そのまま、そのリズムを愛し続けるんだ」';
    } else if (routineRate > 0.5) {
      return '「悪くない。人生にはノイズが付きものだ。レコードの針が少し飛んだくらいで、音楽を止める必要はない。あんたの眠りも同じさ。少しのリズムの乱れなんて、むしろ人間らしくていいじゃないか。明日はもう少し、針を優しく落としてみなよ」';
    } else if (quality < 0.4) {
      return '「ずいぶんとお疲れのようだね。眠れない夜っていうのは、出口のない迷路に迷い込んだような気分になるものだ。でもね、迷路の壁は案外、自分で作っているものかもしれないよ。一度、すべてのルールを忘れて、ただ暗闇の中に身を投じてみるのはどうだい？」';
    } else {
      return '「睡眠の専門家として言わせてもらえば、あんたは少し考えすぎている。眠りっていうのは、泥棒が忍び込むのを待つようなもんじゃない。あっちから勝手にやってくるのを、ただ窓を開けて待っていればいいんだ。まずは深呼吸をして、斎藤の話でも思い出しながら目を閉じてごらん」';
    }
  }
}
