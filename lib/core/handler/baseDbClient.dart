import 'package:sqflite/sqflite.dart';
import 'package:todo/data/repositories/database_helper.dart';

class BaseClient {
  static final DatabaseHelper _databaseHelper = DatabaseHelper();

  static Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await _databaseHelper.database;
    return await db.insert(table, values);
  }

  static Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await _databaseHelper.database;
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  static Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await _databaseHelper.database;
    return await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  static Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await _databaseHelper.database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
