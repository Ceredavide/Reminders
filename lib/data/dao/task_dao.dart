import '../db_config.dart';
import '../models/task.dart';

class TaskDAO {
  static Future<Task?> addTask(Task task) async {
    final db = await DBConfig.instance.database;
    final int id = await db.insert('tasks', task.toMap());

    return await getTaskById(id);
  }

  static Future<Task?> toggleTask(int taskId, bool currentStatus) async {
    final db = await DBConfig.instance.database;

    await db.update(
      'tasks',
      {'isCompleted': currentStatus ? 0 : 1},
      where: 'id = ?',
      whereArgs: [taskId],
    );

    return await getTaskById(taskId);
  }

  static Future<int> deleteTask(int id) async {
    final db = await DBConfig.instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Task>> _getTasksWithFilters(
      String? where, List<dynamic>? whereArgs) async {
    final db = await DBConfig.instance.database;
    final result = await db.rawQuery('''
    SELECT tasks.*, categories.name AS categoryName
    FROM tasks
    LEFT JOIN categories
    ON tasks.categoryId = categories.id
    ${where != null ? 'WHERE $where' : ''}
    ORDER BY dueDateTime ASC
  ''', whereArgs);
    return result.map((json) => Task.fromMap(json)).toList();
  }

  static Future<List<Task>> getTasks() async {
    return await _getTasksWithFilters(null, null);
  }

  static Future<Task?> getTaskById(int id) async {
    final db = await DBConfig.instance.database;
    final result = await db.rawQuery('''
    SELECT tasks.*, categories.name AS categoryName
    FROM tasks
    LEFT JOIN categories
    ON tasks.categoryId = categories.id
    WHERE tasks.id = ?
  ''', [id]);

    if (result.isNotEmpty) {
      return Task.fromMap(result.first);
    } else {
      return null;
    }
  }

  static Future<List<Task>> getTasksByStatus(bool isCompleted) async {
    return await _getTasksWithFilters(
        'tasks.isCompleted = ?', [isCompleted ? 1 : 0]);
  }

  static Future<List<Task>> getTodayTasks() async {
    final DateTime now = DateTime.now();
    final String startOfDay =
        DateTime(now.year, now.month, now.day).toIso8601String();
    final String endOfDay =
        DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();

    return await _getTasksWithFilters(
        'tasks.dueDateTime BETWEEN ? AND ?', [startOfDay, endOfDay]);
  }

  static Future<List<Task>> getTasksByCategory(String categoryName) async {
    return await _getTasksWithFilters('categories.name = ?', [categoryName]);
  }
}
