import 'package:flutter/material.dart';
import 'package:moblab/services/task_service.dart';

import '../data/models/task.dart';
import '../widgets/task/task_item.dart';

class TaskListPage extends StatefulWidget {
  final String taskFilter;
  final String categoryName;

  const TaskListPage(
      {super.key, required this.taskFilter, this.categoryName = ''});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late Future<List<Task>> taskList;

  @override
  void initState() {
    super.initState();
    taskList = TaskService.fetchTasks(
      taskFilter: widget.taskFilter,
      categoryName: widget.categoryName,
    );
  }

  void _toggleTask(Task task) async {
    await TaskService.toggleTask(task);
    _reloadTasks();
  }

  void _deleteTask(int taskId) async {
    await TaskService.deleteTask(taskId);
    _reloadTasks();
  }

  Future<void> _reloadTasks() async {
    final tasks = await TaskService.fetchTasks(
      taskFilter: widget.taskFilter,
      categoryName: widget.categoryName,
    );
    setState(() {
      taskList = Future.value(tasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Task List"),
        ),
        body: FutureBuilder<List<Task>>(
          future: taskList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No tasks found"));
            }

            final tasks = snapshot.data!;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskItem(
                  task: task,
                  onToggle: () => _toggleTask(task),
                  onDelete: () => _deleteTask(task.id),
                );
              },
            );
          },
        ));
  }
}
