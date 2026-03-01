import 'package:drift/drift.dart';

@DataClassName('Task')
class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get routineType => text()();  // "evening" | "morning"
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
