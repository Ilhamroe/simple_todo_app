import 'package:hive/hive.dart';

class TodoService {
  static const String _boxName = 'todoBox';

  // Open the Hive box
  static Future<Box> openBox() async {
    final box = await Hive.openBox(_boxName);

    // Debug: Pastikan box terbuka dengan benar
    print('Box opened: $_boxName');

    return box;
  }

  // Save a new todo to Hive
  static Future<void> saveTodo(String image, String description, int favoriteRating,
      DateTime startTime, DateTime endTime) async {
    var box = await openBox();

    // Create a new todo item
    final newTodo = {
      'image': image,
      'description': description,
      'favoriteRating': favoriteRating,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };

    // Add the new todo
    await box.add(newTodo);

    // Debug: Cek apakah data berhasil ditambahkan
    print('Todo added: $newTodo');
  }

  // Get all todos from Hive
  static Future<List<Map<String, dynamic>>> getAllData() async {
    var box = await openBox();

    List<Map<String, dynamic>> todos = [];

    // Retrieve all todos
    for (int i = 0; i < box.length; i++) {
      final todo = box.getAt(i);
      print('Todo loaded: $todo');

      todos.add({
        'id': i, // Store the index as ID
        'image': todo['image'],
        'description': todo['description'],
        'favoriteRating': todo['favoriteRating'],
        'startTime': DateTime.parse(todo['startTime']),
        'endTime': DateTime.parse(todo['endTime']),
      });
    }

    return todos;
  }

  // Get a todo by ID (Hive index)
  static Future<Map<String, dynamic>?> getDataById(int id) async {
    var box = await openBox();

    if (id >= 0 && id < box.length) {
      final todo = box.getAt(id);
      print('Todo loaded by ID: $todo');

      return {
        'id': id,
        'image': todo['image'],
        'description': todo['description'],
        'favoriteRating': todo['favoriteRating'],
        'startTime': DateTime.parse(todo['startTime']),
        'endTime': DateTime.parse(todo['endTime']),
      };
    } else {
      print('Todo with ID $id not found');
      return null;
    }
  }

  // Update a todo by its ID (Hive index)
  static Future<void> updateDataById(int id, String image, String description,
      int favoriteRating, DateTime startTime, DateTime endTime) async {
    var box = await openBox();

    if (id >= 0 && id < box.length) {
      final updatedTodo = {
        'image': image,
        'description': description,
        'favoriteRating': favoriteRating,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      };

      // Update the todo at the specified index
      await box.putAt(id, updatedTodo);

      print('Todo updated at ID $id: $updatedTodo');
    } else {
      print('Todo with ID $id not found');
    }
  }

  // Delete a todo by its ID (Hive index)
  static Future<void> deleteDataById(int id) async {
    var box = await openBox();

    if (id >= 0 && id < box.length) {
      // Delete the todo at the specified index
      await box.deleteAt(id);

      print('Todo deleted at ID $id');
    } else {
      print('Todo with ID $id not found');
    }
  }

  // Delete all todos from Hive
  static Future<void> deleteAllTodos() async {
    var box = await openBox();
    await box.clear();
    print('All todos have been deleted');
  }
}