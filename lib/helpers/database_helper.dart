import 'package:password_keeper/models/password.dart';
import 'package:password_keeper/models/password_table.dart';
import 'package:password_keeper/models/user.dart';
import 'package:password_keeper/models/users_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

const String dbName = "passwords.db";

class DatabaseHelper {
  static Database _database;

  Future<Database> get database async =>
      _database = _database ?? await initializeDatabase();

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + dbName;

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path,
        version: 1, onCreate: _createDb, onConfigure: _onConfigure);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(UsersTable.createCommand);
    await db.execute(PasswordsTable.createCommand);
  }

  Future<int> createUser(User user) async =>
      await UsersTable().createUser(user, await this.database);
  Future<User> getUser(String email, String password) async =>
      await UsersTable().getUser(email, password, await this.database);
  Future<int> updateUser(User user) async =>
      await UsersTable().updateUser(user, await this.database);

  Future<int> createPassword(Password password) async =>
      await PasswordsTable().createPassword(password, await this.database);
  Future<Password> getPassword(int passwordid) async =>
      await PasswordsTable().getPassword(passwordid, await this.database);
  Future<int> updatePassword(Password password) async =>
      await PasswordsTable().updatePassword(password, await this.database);
  Future<int> deletePassword(int passwordId) async =>
      await PasswordsTable().deletePassword(passwordId, await this.database);
  Future<List<Password>> getAllPassword() async =>
      await PasswordsTable().getAllPasswords(await this.database);

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }
}
