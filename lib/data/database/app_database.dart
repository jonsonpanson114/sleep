import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/settings_table.dart';
import 'tables/tasks_table.dart';
import 'tables/logs_table.dart';
import 'tables/achievements_table.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbDir.path, 'sleep_routine.db'));
    return NativeDatabase.createInBackground(file, logStatements: true);
  });
}

@DriftDatabase(tables: [
  SettingsTable,
  TasksTable,
  LogsTable,
  AchievementsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  /// 初回起動時にデフォルトデータをシード
  Future<void> seedDefaultData() async {
    // デフォルト設定がなければ作成
    final existingSettings = await select(settingsTable).get();
    if (existingSettings.isEmpty) {
      await into(settingsTable).insert(SettingsTableCompanion.insert(
        bedtimeHour: 22,
        bedtimeMinute: 30,
        wakeHour: 6,
        wakeMinute: 30,
        bedtimeNotifEnabled: const Value(true),
        wakeNotifEnabled: const Value(true),
        reminderOffsetMinutes: const Value(30),
      ));
    }

    // デフォルトタスクがなければ作成
    final existingTasks = await select(tasksTable).get();
    if (existingTasks.isEmpty) {
      await batch((b) {
        b.insertAll(tasksTable, [
          TasksTableCompanion.insert(
            id: 'evening-1',
            title: '歯磨き',
            routineType: 'evening',
            sortOrder: 0,
          ),
          TasksTableCompanion.insert(
            id: 'evening-2',
            title: 'スマホを置く',
            routineType: 'evening',
            sortOrder: 1,
          ),
          TasksTableCompanion.insert(
            id: 'evening-3',
            title: 'ストレッチ 5分',
            routineType: 'evening',
            sortOrder: 2,
          ),
          TasksTableCompanion.insert(
            id: 'morning-1',
            title: '水を飲む',
            routineType: 'morning',
            sortOrder: 0,
          ),
          TasksTableCompanion.insert(
            id: 'morning-2',
            title: 'ベッドを整える',
            routineType: 'morning',
            sortOrder: 1,
          ),
          TasksTableCompanion.insert(
            id: 'morning-3',
            title: 'ストレッチ',
            routineType: 'morning',
            sortOrder: 2,
          ),
        ]);
      });
    }
  }
}
