class Task {
  final int id;
  final String title;
  final DateTime dueDateTime;
  final int? categoryId;
  final String? categoryName;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.dueDateTime,
    this.categoryId,
    this.categoryName,
    this.isCompleted = false,
  });

  Task.newTask({
    required this.title,
    required this.dueDateTime,
    this.categoryId,
    this.isCompleted = false,
  })  : id = -1,
        categoryName = null;

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      dueDateTime: DateTime.parse(map['dueDateTime'] as String),
      categoryId: map['categoryId'] as int?,
      categoryName: map['categoryName'] as String?,
      isCompleted: (map['isCompleted'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id > 0) 'id': id,
      'title': title,
      'dueDateTime': dueDateTime.toIso8601String(),
      if (categoryId != null) 'categoryId': categoryId,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  static Object toWidgetMap(Task task) {
    final timeFormatted =
        '${task.dueDateTime.hour.toString().padLeft(2, '0')}:${task.dueDateTime.minute.toString().padLeft(2, '0')}';

    final taskWidgetObj = {
      'id': task.id,
      'title': task.title,
      'due': timeFormatted,
    };

    return taskWidgetObj;
  }

  bool get isToday {
    return DateTime.now().year == dueDateTime.year &&
        DateTime.now().month == dueDateTime.month &&
        DateTime.now().day == dueDateTime.day;
  }
}
