import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(String) onAdd;

  const AddCategoryDialog({
    super.key,
    required this.onAdd,
  });

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _categoryController = TextEditingController();
  String? _errorMessage;

  void _validateAndSubmit() {
    if (_categoryController.text.isEmpty) {
      setState(() {
        _errorMessage = "Category name cannot be empty.";
      });
    } else {
      widget.onAdd(_categoryController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _categoryController,
              decoration:
                  const InputDecoration(hintText: 'Enter category name'),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
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
