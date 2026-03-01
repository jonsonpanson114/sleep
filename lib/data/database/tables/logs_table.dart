import 'package:drift/drift.dart';

@DataClassName('Log')
class LogsTable extends Table {
  TextColumn get dateKey => text()();
  TextColumn get completedTaskIds => text()();
  BoolColumn get eveningCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get morningCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get eveningCompletedAt => dateTime().nullable()();
  DateTimeColumn get morningCompletedAt => dateTime().nullable()();
  BoolColumn get napTaken => boolean().nullable()();
  BoolColumn get daytimeSleepiness => boolean().nullable()();
  BoolColumn get feltIrritable => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {dateKey};
}
