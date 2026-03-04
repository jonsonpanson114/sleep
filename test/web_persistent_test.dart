import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep/domain/entities/daily_log.dart';
import 'package:sleep/domain/use_cases/toggle_task.dart';
import 'package:sleep/data/repositories/web_persistent.dart';

void main() {
  test('toggleTask web persistent test', () async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final logRepo = WebLogPersistent();
    
    // Simulate what toggleTask does
    final currentLog = await logRepo.getTodayLog();
    final log = currentLog ??
        DailyLog(
          date: DateTime.now(),
          completedTaskIds: const [],
          eveningCompleted: false,
          morningCompleted: false,
        );
        
    final toggle = ToggleTask();
    final updatedLog = toggle.execute(log, 'e1');
    print('Trying to save log. completion: ${updatedLog.completedTaskIds}');
    
    try {
      await logRepo.saveLog(updatedLog);
      print('Save completed. Fetching today log...');
      final savedLog = await logRepo.getTodayLog();
      print('Fetched log length: ${savedLog?.completedTaskIds.length}');
      print('Fetched log snapshot: ${savedLog?.eveningTaskSnapshot}');
    } catch(e, st) {
      import('dart:io').then((io) {
        io.File('error_log.txt').writeAsStringSync('ERROR OCCURRED: $e\n$st');
      });
      print('ERROR OCCURRED: $e');
    }
  });
}
