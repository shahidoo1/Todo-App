// todo_list_view.dart
import 'package:flutter/material.dart';

import 'package:todo_application/view_model.dart/todo_view_model.dart';
import 'package:todo_application/widgets/todo_Edit_dailog_box.dart';
import 'package:todo_application/widgets/todo_card.dart';

class TodoListView extends StatelessWidget {
  final TodosViewModel viewModel = TodosViewModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Todo List',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder(
            future: viewModel.fetchTodos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: viewModel.todos.length,
                  itemBuilder: (context, index) {
                    final todo = viewModel.todos[index];
                    return TodoCardWidget(
                      todo: todo,
                      onCheckboxChanged: (isCompleted) {
                        viewModel
                            .updateTodo(todo.copy(isCompleted: isCompleted));
                      },
                      onEditPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => EditTodoDialog(todo, viewModel),
                        );
                        await viewModel.fetchTodos();
                      },
                      onDeletePressed: () async {
                        await viewModel.deleteTodo(todo);
                        await viewModel.fetchTodos();
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
