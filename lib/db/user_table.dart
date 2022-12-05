import 'dart:math';

import 'package:path/path.dart';
import 'package:speekup_v2/db/database_helper.dart';
import 'package:speekup_v2/model/user.dart';
import 'package:sqflite/sqflite.dart';

class UserTable {
  static String tableName = "users";
  final dbHelper = DB.instance;

  // UserTable({
  //   required this.database,
  // }) : super();

  // ignore: empty_constructor_bodies
  // Future<bool> initTable() async {
  //   final db = await dbHelper.database;
  //   const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

  //   const String textType = 'TEXT NOT NULL';
  //   try { 
  //     await database.execute('''
  //       CREATE TABLE IF NOT EXISTS $tableName (
  //         ${UserFields.id} $idType,
  //         ${UserFields.username} $textType,
  //         ${UserFields.fullname} $textType,
  //         ${UserFields.password} $textType
  //       )
  //       ''');
  //     print("object");
  //     await database.insert(
  //         tableName,
  //         UserModel(username: 'admin', fullname: "Admin", password: 'admin')
  //             .toJson());

  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<UserModel> create(UserModel user) async {
    final db = await dbHelper.database;
    final id = await db?.insert(tableName, user.toJson());
    return user.copy(id: id);
  }

  Future<UserModel> readUser(int id) async {
    final db = await dbHelper.database;
    final maps = await db?.query(tableName,
        columns: UserFields.values,
        where: '${UserFields.id} = ?',
        whereArgs: [id]);

    if (maps!.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<UserModel?> getLoginUser(String username, String password) async {
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
