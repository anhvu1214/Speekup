import 'dart:collection';
import 'dart:math';

import 'package:path/path.dart';
import 'package:speekup_v2/model/user.dart';
import 'package:speekup_v2/db/user_table.dart';
import 'package:sqflite/sqflite.dart';

String tableUsers = "users";

class DB {
  static final DB instance = DB._init();

  static Database? _database;

  static UserTable? userTable;

  DB._init();
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB('speekup.db');

    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(filePath, version: 1, onCreate: _initTables);
  }

  Future _initTables(Database db, int version) async {
    // userTable = UserTable(database: db);
    // await userTable!.initTable();
        // final db = await dbHelper.database;
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    const String textType = 'TEXT NOT NULL';
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableUsers (
          ${UserFields.id} $idType,
          ${UserFields.username} $textType,
          ${UserFields.fullname} $textType,
          ${UserFields.password} $textType
        )
        ''');
      await db.insert(
          tableUsers,
          UserModel(username: 'admin', fullname: "Admin", password: 'admin')
              .toJson());
  }

  Future close() async {
    final db = await instance.database;

    db?.close();
  }

  UserTable? getUserTable() {
    return userTable;
  }

}
