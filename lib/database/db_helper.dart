import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_application/models.dart/todo.dart';

class TodosDatabase {
  static final TodosDatabase instance = TodosDatabase._init();

  static Database? _database;

  TodosDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const dateTimeType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE ${TodoFields.values[0]} (
      ${TodoFields.id} $idType,
      ${TodoFields.title} $textType,
      ${TodoFields.description} $textType,
      ${TodoFields.createdTime} $dateTimeType,
      ${TodoFields.dueDate} $dateTimeType,
      ${TodoFields.isCompleted} $boolType
    )
  ''');
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;

    final id = await db.insert(
      TodoFields.values[0],
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return todo.copy(id: id);
  }

  Future<List<Todo>> readAllTodos() async {
    final db = await instance.database;

    final orderBy = '${TodoFields.createdTime} ASC';

    final result = await db.query(TodoFields.values[0], orderBy: orderBy);

    return result.map((json) => Todo.fromJson(json)).toList();
  }

  Future<int> update(Todo todo) async {
    final db = await instance.database;

    return db.update(
      TodoFields.values[0],
      todo.toJson(),
      where: '${TodoFields.id} = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      TodoFields.values[0],
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
