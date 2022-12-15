import 'dart:math';

import 'package:path/path.dart';
import 'package:speekup_v2/db/database_helper.dart';
import 'package:speekup_v2/model/user.dart';
import 'package:sqflite/sqflite.dart';

class UserTable {
  static String tableName = "users";
  final dbHelper = DB.instance;

  Future<UserModel> create(UserModel user) async {
    final db = await dbHelper.database;
    final id = await db?.insert(tableName, user.toJson());
    return user.copy(id: id);
  }

  Future<UserModel> getUser(String username) async {
    final db = await dbHelper.database;
    final maps = await db?.query(tableName,
        columns: UserFields.values,
        where: '${UserFields.username} = ?',
        whereArgs: [username]);

    if (maps!.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      throw Exception('Username $username not found');
    }
  }

  Future<UserModel?> authenticateUser(String username, String password) async {
    final db = await dbHelper.database;
    // final res = database.query(tableUsers,
    //     columns: UserFields.values,
    //     where: '${UserFields.username} = ? and ${UserFields.password} = ?',
    //     whereArgs: [username, password]);
    var res = await db?.rawQuery("SELECT * FROM $tableName WHERE "
        "${UserFields.username} = '$username' AND "
        "${UserFields.password} = '$password'");

    if (res!.isNotEmpty) {
      return UserModel.fromJson(res.first);
    } else {
      return null;
    }
  }

    Future<bool> isValidUsername (String username) async {
    final db = await dbHelper.database;
    var res = await db?.rawQuery("SELECT * FROM $tableName WHERE "
        "${UserFields.username} = '$username'");

    if (res!.isEmpty) {
      return false;
    }
    return true;
  }

  Future<int> update(UserModel user) async {
    final db = await dbHelper.database;

    return db!.update(
      tableName,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db!
        .delete(tableName, where: '${UserFields.id} = ?', whereArgs: [id]);
  }
}
