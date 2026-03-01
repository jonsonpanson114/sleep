import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor connect() {
  return WebDatabase('sleep_routine', logStatements: true);
}
