import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../../data/models/category.dart';

class AddTaskDialog extends StatefulWidget {
  final TextEditingController taskController;
  final Function(String, int?, DateTime, bool) onAdd;
  final List<Category> categories;

  const AddTaskDialog({
    super.key,
    required this.taskController,
    required this.onAdd,
    required this.categories,
  });

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  DateTime _selectedDateTime = DateTime.now();
  int _selectedCategoryIndex = 0;
  bool _notify = false;
  String? _errorMessage;

  String _formattedDateTime(DateTime dateTime) {
    final date = '${dateTime.toLocal()}'.split(' ')[0];
    return date;
  }

  bool _isPastDate(DateTime dateTime) {
    return dateTime.isBefore(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 216,
          color: CupertinoColors.systemBackground,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDateTime,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _selectedDateTime = DateTime(
                  newDate.year,
                  newDate.month,
                  newDate.day,
                  _selectedDateTime.hour,
                  _selectedDateTime.minute,
                );
              });
            },
          ),
        ),
      );
    } else {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            _selectedDateTime.hour,
            _selectedDateTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 216,
          color: CupertinoColors.systemBackground,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: _selectedDateTime,
            onDateTimeChanged: (DateTime newTime) {
              setState(() {
                _selectedDateTime = DateTime(
                  _selectedDateTime.year,
                  _selectedDateTime.month,
                  _selectedDateTime.day,
                  newTime.hour,
                  newTime.minute,
                );
              });
            },
          ),
        ),
      );
    } else {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            _selectedDateTime.year,
            _selectedDateTime.month,
            _selectedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _showCategoryPicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground,
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32.0,
            scrollController: FixedExtentScrollController(
              initialItem: _selectedCategoryIndex,
            ),
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            children: widget.categories
                .map((category) => Center(child: Text(category.name)))
                .toList(),
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    if (widget.taskController.text.isEmpty) {
      setState(() {
        _errorMessage = "Task title cannot be empty.";
      });
    } else if (_isPastDate(_selectedDateTime)) {
      setState(() {
        _errorMessage = "Due date cannot be in the past.";
      });
    } else {
      final selectedCategoryId = widget.categories.isNotEmpty
          ? widget.categories[_selectedCategoryIndex].id
          : null;

      widget.onAdd(
        widget.taskController.text,
        selectedCategoryId,
        _selectedDateTime,
        _notify,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategoryName = widget.categories.isNotEmpty &&
            _selectedCategoryIndex < widget.categories.length
        ? widget.categories[_selectedCategoryIndex].name
        : 'Not set';

    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: const Text('Add Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoTextField(
                  controller: widget.taskController,
                  placeholder: 'Enter task title',
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: CupertinoColors.destructiveRed,
                        fontSize: 13,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Due Date: '),
                    CupertinoButton(
                      onPressed: () => _selectDate(context),
                      child: Text(_formattedDateTime(_selectedDateTime)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Due Time: '),
                    CupertinoButton(
                      onPressed: () => _selectTime(context),
                      child: Text(
                        TimeOfDay.fromDateTime(_selectedDateTime)
                            .format(context),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Category: '),
                    CupertinoButton(
                      onPressed: _showCategoryPicker,
                      child: Text(selectedCategoryName),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CupertinoSwitch(
                      value: _notify,
                      onChanged: (value) {
                        setState(() {
                          _notify = value;
                        });
                      },
                    ),
                    const Text("Receive Notification"),
                  ],
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: _validateAndSubmit,
                child: const Text('Add'),
              ),
            ],
          )
        : AlertDialog(
            title: const Text('Add Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: widget.taskController,
                    decoration:
                        const InputDecoration(hintText: 'Enter task title'),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Due Date: '),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: Text(_formattedDateTime(_selectedDateTime)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Due Time: '),
                      TextButton(
                        onPressed: () => _selectTime(context),
                        child: Text(
                          TimeOfDay.fromDateTime(_selectedDateTime)
                              .format(context),
                        ),
                      ),
                    ],
                  ),
                  DropdownButton<int>(
                    hint: const Text('Select Category'),
                    value: widget.categories.isNotEmpty
                        ? widget.categories[_selectedCategoryIndex].id
                        : null,
                    onChanged: (int? newValue) {
                      final index = widget.categories
                          .indexWhere((category) => category.id == newValue);
                      if (index != -1) {
                        setState(() => _selectedCategoryIndex = index);
                      }
                    },
                    items: widget.categories
                        .map((category) => DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            ))
                        .toList(),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _notify,
                        onChanged: (value) {
                          setState(() {
                            _notify = value!;
                          });
                        },
                      ),
                      const Text('Receive Notification'),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: _validateAndSubmit,
                child: const Text('Add'),
              ),
            ],
          );
  }
}
