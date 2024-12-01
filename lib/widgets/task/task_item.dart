import 'package:flutter/material.dart';

import '../../data/models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildCompletionCheckbox(),
            const SizedBox(width: 12),
            Expanded(child: _buildTaskDetails(context)),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionCheckbox() {
    return Checkbox(
      key: ValueKey(task.isCompleted),
      value: task.isCompleted,
      onChanged: (_) => onToggle(),
      activeColor: Colors.green,
    );
  }

  Widget _buildTaskDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTaskTitle(),
        const SizedBox(height: 12),
        _buildTaskMetadata(context),
      ],
    );
  }

  Widget _buildTaskTitle() {
    return Text(
      task.title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTaskMetadata(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (task.categoryName != null) _buildCategoryInfo(),
        const SizedBox(height: 8),
        _buildDueDateInfo(context),
      ],
    );
  }

  Widget _buildCategoryInfo() {
    return Row(
      children: [
        const Icon(Icons.category, size: 18, color: Colors.blue),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            task.categoryName!,
            style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDueDateInfo(BuildContext context) {
    final datePart = _formatDate(task.dueDateTime);
    final timePart = TimeOfDay.fromDateTime(task.dueDateTime).format(context);

    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 18, color: Colors.orange),
        const SizedBox(width: 6),
        Text(
          datePart,
          style: TextStyle(fontSize: 14, color: Colors.orange.shade700),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.access_time, size: 18, color: Colors.red),
        const SizedBox(width: 6),
        Text(
          timePart,
          style: TextStyle(fontSize: 14, color: Colors.red.shade700),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: onDelete,
      tooltip: 'Delete Task',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
