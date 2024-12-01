import 'dart:convert';

import '../widget/widget_config.dart';
import '../../data/models/task.dart';

const String group = 'group.com.ceredavide.moblab.widget';

const String widgetName = 'HomeWidget';

const int maxTasks = 3;

class HomeWidget {
  static Future<void> init() async {
    await WidgetConfig.init(group);
  }

  static Future<void> updateTasksOnWidget(List<Task> tasks) async {
    tasks = tasks.where((task) => !task.isCompleted).take(maxTasks).toList();

    List<Object> tasksMapList =
        tasks.map((task) => Task.toWidgetMap(task)).toList();

    String tasksJson = jsonEncode(tasksMapList);

    await WidgetConfig.saveWidgetData('tasks', tasksJson);

    await WidgetConfig.updateWidget(widgetName);
  }
}
