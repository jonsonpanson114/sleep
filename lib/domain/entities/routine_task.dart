enum RoutineType { evening, morning }

class RoutineTask {
  final String id;
  final String title;
  final RoutineType type;
  final int sortOrder;

  const RoutineTask({
    required this.id,
    required this.title,
    required this.type,
    required this.sortOrder,
  });

  RoutineTask copyWith({
    String? id,
    String? title,
    RoutineType? type,
    int? sortOrder,
  }) {
    return RoutineTask(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
