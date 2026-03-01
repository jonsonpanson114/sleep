import 'package:drift/drift.dart';

@DataClassName('Achievement')
class AchievementsTable extends Table {
  TextColumn get id => text()();  // achievement.id と同じ
  DateTimeColumn get unlockedAt => dateTime()();  // 達成日時

  @override
  Set<Column> get primaryKey => {id};
}
