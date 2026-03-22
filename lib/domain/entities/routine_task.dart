enum RoutineType { evening, morning }

class RoutineTask {
  final String id;
  final String title;
  final RoutineType type;
  final int sortOrder;
  final String? startTime; // HH:mm
  final String? endTime;   // HH:mm

  const RoutineTask({
    required this.id,
    required this.title,
    required this.type,
    required this.sortOrder,
    this.startTime,
    this.endTime,
  });

  RoutineTask copyWith({
    String? id,
    String? title,
    RoutineType? type,
    int? sortOrder,
    String? startTime,
    String? endTime,
  }) {
    return RoutineTask(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      sortOrder: sortOrder ?? this.sortOrder,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
