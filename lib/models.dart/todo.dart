// todos.dart

class TodoFields {
  static final List<String> values = [
    id,
    title,
    description,
    createdTime,
    dueDate,
    isCompleted
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String createdTime = 'createdTime';
  static final String dueDate = 'dueDate'; // Added dueDate field
  static String isCompleted = 'isCompleted';
}

class Todo {
  int? id;
  final String title;
  final String description;
  final DateTime createdTime;
  final DateTime dueDate; // Added dueDate field
  final bool isCompleted;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.dueDate,
    required this.isCompleted,
  });

  Todo copy({
    int? id,
    String? title,
    String? description,
    DateTime? createdTime,
    DateTime? dueDate,
    bool? isCompleted,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
        dueDate: dueDate ?? this.dueDate,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  static Todo fromJson(Map<String, Object?> json) => Todo(
        id: json[TodoFields.id] as int?,
        title: json[TodoFields.title] as String,
        description: json[TodoFields.description] as String,
        createdTime: DateTime.parse(json[TodoFields.createdTime] as String),
        dueDate:
            DateTime.parse(json[TodoFields.dueDate] as String), // Parse dueDate
        isCompleted: json[TodoFields.isCompleted] == 1,
      );

  Map<String, Object?> toJson() => {
        TodoFields.id: id,
        TodoFields.title: title,
        TodoFields.description: description,
        TodoFields.createdTime: createdTime.toIso8601String(),
        TodoFields.dueDate:
            dueDate.toIso8601String(), // Convert dueDate to ISO 8601 format
        TodoFields.isCompleted: isCompleted ? 1 : 0, // Store boolean as 0 or 1
      };
}
