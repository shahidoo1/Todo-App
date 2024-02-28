import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:todo_application/models.dart/todo.dart';
import 'package:todo_application/view_model.dart/todo_view_model.dart';

class AddTodoDialog extends StatefulWidget {
  final TodosViewModel viewModel;
  final Todo? todo;

  AddTodoDialog(this.viewModel, {this.todo});

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? selectedDate; // Make it nullable to check if a date is selected

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    // If editing existing todo, set initial values
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      selectedDate = widget.todo!.dueDate;
    }
  }

  // Function to check if the title and date are selected
  bool isFormValid() {
    return _titleController.text.isNotEmpty && selectedDate != null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title ',
              errorText: isFormValid() ? null : 'Please add tittle',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 8),
          // DatePicker for selecting due date
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            child: Text(
              selectedDate == null
                  ? 'Select  Date '
                  : 'Date: ${DateFormat('dd-MM-yyyy').format(selectedDate!)}',
              style: TextStyle(
                color: selectedDate == null ? Colors.red : null,
              ),
            ),
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
            if (isFormValid()) {
              final newTodo = Todo(
                title: _titleController.text,
                description: _descriptionController.text,
                createdTime: DateTime.now(),
                dueDate: selectedDate!,
                isCompleted: false,
              );

              // If editing existing todo, set the id
              if (widget.todo != null) {
                newTodo.id = widget.todo!.id;
              }

              await widget.viewModel.addTodo(newTodo);
              Navigator.of(context).pop();
            } else {
              // Show an error message if the form is not valid
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please fill in the mandatory fields.'),
                ),
              );
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
