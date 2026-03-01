import 'dart:math';

class DailyAdvice {
  final String title;
  final String content;
  final String emoji;

  DailyAdvice({required this.title, required this.content, required this.emoji});
}

class DailyAdviceSpecialist {
  static final List<DailyAdvice> _pool = [
    DailyAdvice(
      title: '羊の数え方',
      content: '羊を数えるのは、あれはイギリスの話だ。「Sheep」と「Sleep」の発音が似てるから脳が勘違いするらしい。日本語なら「イモ」でも「カツオ」でも似たようなもんだ。要は、どうでもいいことを考えるのが一番ってことだよ。',
      emoji: '🐑',
    ),
    DailyAdvice(
      title: '信号待ちの哲学',
      content: '赤信号でイライラしても信号は早く変わらないだろ？ 睡眠も同じだ。早く寝なきゃと焦るほど、脳は「あ、これ緊急事態だ」と誤解して起きてようとする。寝る前くらい、世界が滅びるのを待ってるくらいの余裕を持ちな。',
      emoji: '🚥',
    ),
    DailyAdvice(
      title: '枕の高さ',
      content: '高い枕が好きな奴は、プライドが高いか、あるいは単に首の骨の形が特殊なだけだ。まあ、どっちでもいいが、高すぎる枕は呼吸を浅くする。プライドは捨てても、呼吸は捨てるなよ。',
      emoji: '🛌',
    ),
    DailyAdvice(
      title: '朝の太陽',
      content: '朝の光を浴びるのは、脳の時計をリセットするためだ。リセットボタンがあるだけ、人間はコンピュータより便利にできてる。押さない手はないだろ？ 窓を開けるだけで、今日という新しい物語が始まるんだ。',
      emoji: '☀️',
    ),
    DailyAdvice(
      title: 'カフェインの正体',
      content: 'カフェインは「元気の前借り」だ。借金はいつか返さなきゃいけない。午後3時以降のコーヒーは、明日の朝の自分から元気を奪ってる。不器用な生き方をするのはいいが、借金まみれになるのはスマートじゃないな。',
      emoji: '☕',
    ),
    DailyAdvice(
      title: '夢の続き',
      content: '夢の続きを見ようとして二度寝するのは、読みかけの本を無理やり閉じるようなもんだ。結末なんて大したことない。それより、現実の続きを面白いものにする努力をするほうが、よっぽど生産的だとは思わないか？',
      emoji: '🌙',
    ),
    DailyAdvice(
      title: '寝室のスマホ',
      content: 'スマホを寝室に持ち込むのは、枕元に拡声器を持ったセールスマンを立たせてるのと同じだ。あいつらは24時間、お前の注意を引こうと必死だ。いいか、夜の時間は誰にも売るな。お前だけの聖域だ。',
      emoji: '📱',
    ),
  ];

  static DailyAdvice getAdvice() {
    // 日替わりで出すために日付をシードにする
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final index = Random(seed).nextInt(_pool.length);
    return _pool[index];
  }
}
