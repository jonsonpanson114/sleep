import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep/domain/entities/daily_log.dart';
import 'package:sleep/domain/use_cases/toggle_task.dart';
import 'package:sleep/data/repositories/web_persistent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  final logRepo = WebLogPersistent();
  
  try {
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
    
    await logRepo.saveLog(updatedLog);
    print('Save completed. Fetching today log...');
    final savedLog = await logRepo.getTodayLog();
    print('Fetched log length: ${savedLog?.completedTaskIds.length}');
  } catch(e, st) {
    File('error_log.txt').writeAsStringSync('ERROR OCCURRED: $e\n$st');
    print('Error written to error_log.txt');
  }
}
