import 'package:drift/drift.dart';

@DataClassName('Settings')
class SettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bedtimeHour => integer()();
  IntColumn get bedtimeMinute => integer()();
  IntColumn get wakeHour => integer()();
  IntColumn get wakeMinute => integer()();
  BoolColumn get bedtimeNotifEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get wakeNotifEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get reminderOffsetMinutes => integer().withDefault(const Constant(30))();
}
