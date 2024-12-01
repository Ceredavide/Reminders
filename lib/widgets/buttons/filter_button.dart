import 'package:flutter/material.dart';

import '../../screens/task_list_page.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final String taskFilter;
  final IconData icon;

  const FilterButton({
    super.key,
    required this.label,
    required this.taskFilter,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(8),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskListPage(taskFilter: taskFilter),
              ),
            );
          },
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }
}
