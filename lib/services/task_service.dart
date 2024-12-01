import 'package:moblab/services/method_channel.dart';

import 'widget/widget_home.dart';
import 'notifications/notification_task.dart';

import '../data/dao/task_dao.dart';
import '../data/models/task.dart';

class TaskService {
  static Future<bool> createTask(String taskTitle, int? selectedCategory,
      DateTime selectedDateTime, bool sendNotification) async {
    final addedTask = await TaskDAO.addTask(Task.newTask(
      title: taskTitle,
      isCompleted: false,
      categoryId: selectedCategory!,
      dueDateTime: selectedDateTime,
    ));
    if (addedTask != null) {
      if (addedTask.isToday) {
        await handleWidgetUpdate();
      }
      if (sendNotification) {
        await NotificationTask.scheduleTaskNotification(addedTask);
      }
      await AlertMethodChannel.playSound();
      return true;
    } else {
      return false;
    }
  }

  static Future<void> toggleTask(Task task) async {
    final updatedTask = await TaskDAO.toggleTask(task.id, task.isCompleted);
    if (updatedTask != null) {
      await NotificationTask.updateTaskNotification(updatedTask);
      if (updatedTask.isToday) {
        await handleWidgetUpdate();
      }
    }
  }

  static Future<void> deleteTask(int taskId) async {
    await TaskDAO.deleteTask(taskId);
    await NotificationTask.cancelTaskNotification(taskId);
    await handleWidgetUpdate();
  }

  static Future<List<Task>> fetchTasks({
    required String taskFilter,
    String categoryName = '',
  }) async {
    switch (taskFilter) {
      case 'incomplete':
        return await TaskDAO.getTasksByStatus(false);
      case 'completed':
        return await TaskDAO.getTasksByStatus(true);
      case 'today':
        return await TaskDAO.getTodayTasks();
      case 'category':
        return await TaskDAO.getTasksByCategory(categoryName);
      default:
        return await TaskDAO.getTasks();
    }
  }

  static Future<void> handleWidgetUpdate() async {
    List<Task> tasks = await TaskDAO.getTodayTasks();
    await HomeWidget.updateTasksOnWidget(tasks);
  }
}
