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
    print('user $result created');
    return result;
  }

  Future<User> getUser(String email, String password, Database db) async {
    var result = await db.rawQuery(
        "SELECT * FROM $tableName WHERE $colEmail = ? AND $colMasterPassword = ?",
        [email, password]);
    print(result);
    print(result[0]);
    return result.length == 0 ? null : User.fromMapObject(result[0]);
  }

  Future<int> updateUser(User user, Database db) async {
    var result = await db.update(tableName, user.toMap(),
        where: '$colId = ?', whereArgs: [user.id]);
    print('user ${user.id} has updated');
    return result;
  }
}
