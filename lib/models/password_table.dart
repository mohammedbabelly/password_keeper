import 'package:sqflite/sqflite.dart';
import 'password.dart';
import 'users_table.dart';

class PasswordsTable {
  static const String tableName = "passwords";
  static const String colId = "id";
  static const String colUserId = "user_id";
  static const String colTitle = "title";
  static const String colPassword = "password";
  static const String colEmail = "email";
  static const String colNote = "note";
  static const String colDate = "date";
  static const String createCommand = 'CREATE TABLE $tableName('
      '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
      'FOREIGN KEY ($colUserId) REFERENCES ${UsersTable.tableName} (${UsersTable.colId}) ON DELETE NO ACTION ON UPDATE NO ACTION, '
      '$colTitle TEXT, '
      '$colPassword TEXT, '
      '$colEmail TEXT, '
      '$colNote TEXT, '
      '$colDate TEXT';
  Future<int> createPassword(Password password, Database db) async {
    var result = await db.insert(tableName, password.toMap());
    return result;
  }

  Future<Password> getPassword(int passwordId, Database db) async {
    var result =
        await db.query(tableName, where: '$colId = ?', whereArgs: [passwordId]);
    return Password.fromMapObject(result[0]);
  }

  Future<int> updatePassword(Password password, Database db) async {
    var result = await db.update(tableName, password.toMap(),
        where: '$colId = ?', whereArgs: [password.id]);
    return result;
  }

  Future<int> deletePassword(int id, Database db) async {
    int result =
        await db.delete(tableName, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  Future<List<Password>> getAllPasswords(Database db) async {
    List<Map<String, dynamic>> passwordsMapList =
        // await db.rawQuery('SELECT * FROM $tableName');
        await db.query(tableName);
    int count = passwordsMapList.length;

    List<Password> passwordsList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      passwordsList.add(Password.fromMapObject(passwordsMapList[i]));
    }

    return passwordsList;
  }
}
