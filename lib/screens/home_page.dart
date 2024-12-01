import 'package:flutter/material.dart';
import 'package:moblab/services/task_service.dart';
import 'package:moblab/widgets/buttons/category_button.dart';

import '../data/dao/category_dao.dart';
import '../data/models/category.dart';
import '../widgets/buttons/filter_button.dart';
import '../widgets/dialogs/add_task_dialog.dart';
import '../widgets/dialogs/add_category_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFABExpanded = false;
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _toggleFAB() {
    setState(() {
      _isFABExpanded = !_isFABExpanded;
    });
  }

  void _fetchCategories() async {
    final fetchedCategories = await CategoryDAO.getCategories();
    setState(() {
      categories = fetchedCategories;
    });
  }

  void _createTask(String taskTitle, int? selectedCategory,
      DateTime selectedDateTime, bool sendNotification) async {
    await TaskService.createTask(
        taskTitle, selectedCategory, selectedDateTime, sendNotification);
  }

  void _createCategory(String categoryName) async {
    await CategoryDAO.addCategory(categoryName);
    _fetchCategories();
  }

  void _showAddTaskDialog() {
    _toggleFAB();
    showDialog(
      context: context,
      builder: (context) {
        return AddTaskDialog(
          taskController: TextEditingController(),
          categories: categories,
          onAdd: (taskTitle, selectedCategory, selectedDateTime,
              sendNotification) {
            _createTask(taskTitle, selectedCategory, selectedDateTime,
                sendNotification);
          },
        );
      },
    );
  }

  void _showAddCategoryDialog() {
    _toggleFAB();
    showDialog(
      context: context,
      builder: (context) {
        return AddCategoryDialog(
          onAdd: (categoryName) {
            _createCategory(categoryName);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MY Task Manager"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterButton(
                  label: "Task for today",
                  taskFilter: 'today',
                  icon: Icons.calendar_today,
                ),
                FilterButton(
                  label: "All Tasks",
                  taskFilter: 'all',
                  icon: Icons.list,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterButton(
                  label: "Task incompleted",
                  taskFilter: 'incomplete',
                  icon: Icons.check_box_outline_blank,
                ),
                FilterButton(
                  label: "Task completed",
                  taskFilter: 'completed',
                  icon: Icons.check_circle,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            categories.isEmpty
                ? const Center(child: Text("Add some categories!"))
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryButton(
                            categoryName: categories[index].name);
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: _isFABExpanded
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _showAddTaskDialog,
                  tooltip: "Add Task",
                  child: const Icon(Icons.task),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _showAddCategoryDialog,
                  tooltip: "Add Categoria",
                  child: const Icon(Icons.category),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _toggleFAB,
                  tooltip: "Close FAB",
                  child: const Icon(Icons.close),
                ),
              ],
            )
          : FloatingActionButton(
              onPressed: _toggleFAB,
              tooltip: "Expand FAB",
              child: const Icon(Icons.add),
            ),
    );
  }
}
