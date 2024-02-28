// todo_card_widget.dart
import 'package:flutter/material.dart';
import 'package:todo_application/models.dart/todo.dart';

class TodoCardWidget extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onCheckboxChanged; // Update the type to bool?
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  TodoCardWidget({
    required this.todo,
    required this.onCheckboxChanged,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(todo.title),
        subtitle: todo.description.isNotEmpty ? Text(todo.description) : null,
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: onCheckboxChanged,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEditPressed,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDeletePressed,
            ),
          ],
        ),
      ),
    );
  }
}
