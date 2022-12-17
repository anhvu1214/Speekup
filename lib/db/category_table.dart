import 'dart:math';

import 'package:path/path.dart';
import 'package:speekup_v2/db/database_helper.dart';
import 'package:speekup_v2/db/sentence_table.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/model/user.dart';
import 'package:sqflite/sqflite.dart';

class CategoryTable {
  static String tableName = "categories";
  String tableSentenceCategory = "sentence_category";
  final dbHelper = DB.instance;

  Future<CategoryModel> create(CategoryModel category) async {
    final db = await dbHelper.database;
    final id = await db?.insert(tableName, category.toJson());
    return category.copy(id: id);
  }

  Future<List<CategoryModel>> getAllCategoriesByUser(String username) async {
    final db = await dbHelper.database;

    final orderBy = '${CategoryFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db?.query(tableName,
        columns: CategoryFields.values,
        where: '${CategoryFields.username} = ? AND (${CategoryFields.isDeletable} = 1 OR ${CategoryFields.name} = "Đã lưu")',
        whereArgs: [username],
        orderBy: orderBy);

    return result!.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<List<String>> getAllCategoriesBySentence(int sentenceID) async {
    final db = await dbHelper.database;

    final orderBy = '${CategoryFields.id} ASC';
    final qresult = await db?.rawQuery(
        'SELECT categories.* FROM ((sentence_category INNER JOIN sentences ON sentence_category.sentenceID = sentences.id) INNER JOIN categories ON sentence_category.categoryID = categories.id) WHERE sentences.id = $sentenceID ORDER BY $orderBy');
    List<String> res = [];
    // qresult?.forEach((element) {
    //   res.add(CategoryModel.fromJson(element));
    // });
    qresult?.forEach((element) {
      res.add(CategoryModel.fromJson(element).name);
    });
    return res;
  }

  Future<List<CategoryModel>> getEmergencyCategories(String username) async {
    final db = await dbHelper.database;

    final orderBy = '${CategoryFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db?.query(tableName,
        columns: CategoryFields.values,
        where: '${CategoryFields.username} = ? AND (${CategoryFields.isDeletable} = 0 AND ${CategoryFields.name} != "Đã lưu")',
        whereArgs: [username],
        orderBy: orderBy);

    return result!.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<CategoryModel> getCategory(String username,String name) async {
    final db = await dbHelper.database;
    final maps = await db?.query(tableName,
        columns: CategoryFields.values,
        where: '${CategoryFields.username} = ? AND ${CategoryFields.name} = ?',
        whereArgs: [username, name]);

    if (maps!.isNotEmpty) {
      return CategoryModel.fromJson(maps.first);
    } else {
      throw Exception('Category $name not found');
    }
  }

  Future<int> update(CategoryModel category) async {
    final db = await dbHelper.database;

    return db!.update(
      tableName,
      category.toJson(),
      where: '${CategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  Future<bool> delete(int id) async {
    final db = await dbHelper.database;
    try {
      await db!.delete(tableSentenceCategory,
          where: 'categoryID = ?', whereArgs: [id]);
      await SentenceTable().removeRemainSentences();
      await db.delete(tableName,
          where: '${CategoryFields.id} = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }
}
