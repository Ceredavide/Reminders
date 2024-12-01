import 'package:moblab/data/models/task.dart';
import 'package:moblab/services/notifications/notification_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationTask {
  static const String notifiedTasksKey = 'notified_tasks';

  static Future<void> scheduleTaskNotification(Task task) async {
    await NotificationConfig.scheduleNotification(
      notificationId: task.id,
      title: "Task Reminder",
      body: task.title,
      scheduledDate: task.dueDateTime,
    );

    await _saveTaskNotificationStatus(task.id);
  }

  static Future<void> cancelTaskNotification(int taskId) async {
    await NotificationConfig.cancelNotification(taskId);
  }

  static Future<void> updateTaskNotification(Task task) async {
    if (task.isCompleted) {
      await cancelTaskNotification(task.id);
    } else {
      final isToNotify = await _isTaskToNotify(task.id);
      if (isToNotify) {
        await scheduleTaskNotification(task);
      }
    }
  }

  static Future<void> _saveTaskNotificationStatus(int taskId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifiedTasks = prefs.getStringList(notifiedTasksKey) ?? [];
    if (!notifiedTasks.contains(taskId.toString())) {
      notifiedTasks.add(taskId.toString());
      await prefs.setStringList(notifiedTasksKey, notifiedTasks);
    }
  }

  static Future<bool> _isTaskToNotify(int taskId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifiedTasks = prefs.getStringList(notifiedTasksKey) ?? [];
    return notifiedTasks.contains(taskId.toString());
  }
}
