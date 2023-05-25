import 'package:sqflite/sqflite.dart';

import '../model/task.dart';

class DBHelper {
  static Database? _database;
  static final int _version = 1;
  static final String _tableName = 'tasks';

  static Future<void> initDB() async {
    if (_database != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      print('creating a new one');
      _database =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, title TEXT, note TEXT, '
          'isCompleted INTEGER, date TEXT, startTime TEXT, endTime TEXT, color INTEGER, '
          'remind INTEGER, repeat TEXT)',
        );
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    return await _database?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return _database!.query(_tableName);
  }

  static delete(Task task) async {
    return await _database!
        .delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _database!.rawUpdate('''
       UPDATE tasks SET isCompleted = ? WHERE id = ?
        ''', [1, id]);
  }

  // static edit(int id) async{
  //   return await _database!.
  // }
}
