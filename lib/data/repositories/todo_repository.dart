import 'package:todo/core/handler/base_db_client.dart';
import 'package:todo/data/models/todo_model.dart';

class TodoRepository {
  static const String _tableName = "todo";

  static Future<TodoModel> createTodo(TodoModel todo) async {
    try {
      await BaseClient.insert(_tableName, todo.toMap());
      return todo;
    } catch (e) {
      throw Exception("Failed to create todo: $e");
    }
  }

  static Future<List<TodoModel>> getAllTodos() async {
    try {
      final List<Map<String, dynamic>> maps = await BaseClient.query(
        _tableName,
        orderBy: 'updatedAt DESC',
      );
      return maps.map((map) => TodoModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception("Failed to fetch todos: $e");
    }
  }

  static Future<TodoModel?> getTodoById(String id) async {
    try {
      final List<Map<String, dynamic>> maps = await BaseClient.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return TodoModel.fromMap(maps.first);
    } catch (e) {
      throw Exception('Failed to get todo: $e');
    }
  }

  static Future<TodoModel> updateTodo(TodoModel todo) async {
    try {
      final updatedTodo = todo.copyWith(updatedAt: DateTime.now());

      final rowsAffected = await BaseClient.update(
        _tableName,
        updatedTodo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );

      if (rowsAffected == 0) {
        throw Exception('Todo not found for update');
      }

      return updatedTodo;
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  static Future<void> deleteTodo(String id) async {
    try {
      final rowsAffected = await BaseClient.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw Exception('Todo not found for deletion');
      }
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}
