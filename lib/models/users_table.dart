import 'package:sqflite/sqflite.dart';

import 'user.dart';

class UsersTable {
  static const String tableName = "users";
  static const String colId = "id";
  static const String colEmail = "email";
  static const String colMasterPassword = "master_password";
  static const String createCommand =
      'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colEmail TEXT, '
      '$colMasterPassword TEXT)';

  Future<int> createUser(User user, Database db) async {
    var result = await db.insert(tableName, user.toMap());
    return result;
  }

  Future<User> getUser(int userId, Database db) async {
    var result =
        await db.query(tableName, where: '$colId = ?', whereArgs: [userId]);
    return User.fromMapObject(result[0]);
  }

  Future<int> updateUser(User user, Database db) async {
    var result = await db.update(tableName, user.toMap(),
        where: '$colId = ?', whereArgs: [user.id]);
    return result;
  }
}
