import 'package:flutter/material.dart';
import 'package:todo_application/models.dart/todo.dart';
import 'package:todo_application/view_model.dart/todo_view_model.dart';
import 'package:todo_application/widgets/add_todo_task.dart';
import 'package:todo_application/widgets/todo_Edit_dailog_box.dart';
import 'package:todo_application/widgets/todo_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TodosViewModel viewModel = TodosViewModel();
  late List<Todo> todayTodos;
  late List<Todo> tomorrowTodos;
  late List<Todo> upcomingTodos;
  late TabController _tabController;
  late TextEditingController _searchController;
  late String _searchQuery;

  @override
  void initState() {
    super.initState();
    todayTodos = [];
    tomorrowTodos = [];
    upcomingTodos = [];
    _searchController = TextEditingController();
    _searchQuery = '';
    _tabController = TabController(length: 3, vsync: this);
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    await viewModel.fetchTodos();

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfToday = startOfToday.add(Duration(days: 1));

    todayTodos = viewModel.filterTodosByDate(startOfToday, endOfToday);
    tomorrowTodos = viewModel.filterTodosByDate(
        endOfToday, endOfToday.add(Duration(days: 1)));
    upcomingTodos = viewModel.filterTodosUpcoming(endOfToday);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Tomorrow'),
            Tab(text: 'Upcoming'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search  ',
                  icon: Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildSection(todayTodos),
                buildSection(tomorrowTodos),
                buildSection(upcomingTodos),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildSection(List<Todo> todos) {
    // Filter todos based on search query
    List<Todo> filteredTodos =
        _searchQuery.isEmpty ? todos : viewModel.searchTodos(_searchQuery);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: filteredTodos.isEmpty
          ? Center(
              child: Text(
                'No Task ',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];
                return TodoCardWidget(
                  todo: todo,
                  onCheckboxChanged: (value) {
                    final updatedTodo = todo.copy(isCompleted: value);
                    viewModel.updateTodo(updatedTodo);
                    fetchTodos();
                  },
                  onEditPressed: () => showEditTodoDialog(context, todo),
                  onDeletePressed: () {
                    viewModel.deleteTodo(todo);
                    fetchTodos();
                  },
                );
              },
            ),
    );
  }

  Future<void> showAddTodoDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AddTodoDialog(viewModel),
    ).then((_) => fetchTodos());
  }

  Future<void> showEditTodoDialog(BuildContext context, Todo todo) async {
    return showDialog(
      context: context,
      builder: (context) => EditTodoDialog(todo, viewModel),
    ).then((_) => fetchTodos());
  }
}
