// edit_todo_dialog.dart
import 'package:flutter/material.dart';
import 'package:todo_application/models.dart/todo.dart';
import 'package:todo_application/view_model.dart/todo_view_model.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo todo;
  final TodosViewModel viewModel;

  EditTodoDialog(this.todo, this.viewModel);

  @override
  _EditTodoDialogState createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController =
        TextEditingController(text: widget.todo.description);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final updatedTodo = widget.todo.copy(
              title: _titleController.text,
              description: _descriptionController.text,
            );
            await widget.viewModel.updateTodo(updatedTodo);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
