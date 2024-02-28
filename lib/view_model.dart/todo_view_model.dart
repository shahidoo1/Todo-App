// todos_view_model.dart
import 'package:flutter/material.dart';
import 'package:todo_application/database/db_helper.dart';
import 'package:todo_application/models.dart/todo.dart';

class TodosViewModel extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> fetchTodos() async {
    _todos = await TodosDatabase.instance.readAllTodos();
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await TodosDatabase.instance.create(todo);
    await fetchTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await TodosDatabase.instance.update(todo);
    await fetchTodos();
  }

  Future<void> deleteTodo(Todo todo) async {
    await TodosDatabase.instance.delete(todo.id!);
    await fetchTodos();
  }

  List<Todo> filterTodos(String query) {
    return _todos
        .where((todo) =>
            todo.title.toLowerCase().contains(query.toLowerCase()) ||
            todo.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Todo> filterTodosByDate(DateTime startDate, [DateTime? endDate]) {
    return _todos.where((todo) {
      print("Checking todo: ${todo.title}, due date: ${todo.dueDate}");
      return todo.dueDate == startDate;
    }).toList();
  }

  // Method to filter todos based on a search query
  List<Todo> searchTodos(String query) {
    return _todos
        .where((todo) =>
            todo.title.toLowerCase().contains(query.toLowerCase()) ||
            todo.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Todo> filterTodosUpcoming(DateTime startDate, [DateTime? endDate]) {
    return _todos.where((todo) => todo.dueDate.isAfter(startDate)).toList();
  }
}
