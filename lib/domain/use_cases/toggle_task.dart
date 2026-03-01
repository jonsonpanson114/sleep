import '../entities/daily_log.dart';

class ToggleTask {
  DailyLog execute(DailyLog log, String taskId) {
    final ids = [...log.completedTaskIds];

    if (ids.contains(taskId)) {
      ids.remove(taskId);
    } else {
      ids.add(taskId);
    }

    return log.copyWith(completedTaskIds: ids);
  }
}
