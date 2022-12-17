import 'dart:math';

import 'package:path/path.dart';
import 'package:speekup_v2/db/database_helper.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/model/sentence.dart';
import 'package:speekup_v2/model/user.dart';
import 'package:sqflite/sqflite.dart';

class SentenceTable {
  static String tableName = "sentences";
  String tableSentenceCategory = "sentence_category";
  final dbHelper = DB.instance;

  Future<SentenceModel> create(SentenceModel sentence) async {
    final db = await dbHelper.database;
    final id = await db?.insert(tableName, sentence.toJson());

    return sentence.copy(id: id);
  }

  Future<bool> addToCategory(SentenceModel sentence, int categoryID) async {
    final db = await dbHelper.database;
    if (sentence == null || categoryID == null) return false;
    try {
      await db?.insert(tableSentenceCategory,
          {'categoryID': categoryID, 'sentenceID': sentence.id});
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<void> removeFromCategory(
      SentenceModel sentence, int categoryID) async {
    final db = await dbHelper.database;
    int check = await db?.delete(tableSentenceCategory,
        where: 'sentenceID = ? AND categoryID = ?',
        whereArgs: [sentence.id, categoryID]) as int;

    final map = await db?.query(tableSentenceCategory,
        columns: ['sentenceID', 'categoryID'],
        where: 'sentenceID = ?',
        whereArgs: [sentence.id]);

    if (map!.isEmpty) {
      await delete(sentence.id as int);
    }
  }

  Future<int> removeRemainSentences() async {
    final db = await dbHelper.database;

    return await db!.rawDelete(
        'DELETE FROM sentences WHERE sentences.id NOT IN (SELECT sentence_category.sentenceID FROM sentence_category)');
  }

  Future<bool> isExist(String word) async {
    final db = await dbHelper.database;
    final result = await db?.query(tableName,
        columns: SentenceFields.values,
        where: '${SentenceFields.word} = ?',
        whereArgs: [word]);
    if (result!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<SentenceModel> getSentence(String word) async {
    final db = await dbHelper.database;
    final result = await db?.query(tableName,
        columns: SentenceFields.values,
        where: '${SentenceFields.word} = ?',
        whereArgs: [word]);
    if (result!.isNotEmpty) {
      return SentenceModel.fromJson(result.first);
    } else {
      throw Exception('\'$word\' not found');
    }
  }

  Future<List<SentenceModel>> getAllSentencesByCategory(int categoryID) async {
    final db = await dbHelper.database;

    final orderBy = '${SentenceFields.id} ASC';
    final qresult = await db?.rawQuery(
        'SELECT sentences.* FROM ((sentence_category INNER JOIN sentences ON sentence_category.sentenceID = sentences.id) INNER JOIN categories ON sentence_category.categoryID = categories.id) WHERE categories.id = $categoryID ORDER BY $orderBy');
    List<SentenceModel> res = [];
    qresult?.forEach((element) {
      res.add(SentenceModel.fromJson(element));
    });
    return res;
  }

  Future<List<SentenceModel>> getAllSentencesByUser(String username) async {
    final db = await dbHelper.database;

    final orderBy = '${SentenceFields.id} ASC';
    final qresult = await db?.rawQuery(
        'SELECT DISTINCT sentences.* FROM ((sentence_category INNER JOIN sentences ON sentence_category.sentenceID = sentences.id) INNER JOIN categories ON sentence_category.categoryID = categories.id) WHERE categories.username = \'$username\' ORDER BY $orderBy');
    List<SentenceModel> res = [];
    qresult?.forEach((element) {
      res.add(SentenceModel.fromJson(element));
    });
    return res;
  }

  Future<int> update(SentenceModel sentence) async {
    final db = await dbHelper.database;

    return db!.update(
      tableName,
      sentence.toJson(),
      where: '${SentenceFields.id} = ?',
      whereArgs: [sentence.id],
    );
  }

  Future<bool> delete(int id) async {
    final db = await dbHelper.database;
    try {
      await db!.delete(tableSentenceCategory,
          where: 'sentenceID = ?', whereArgs: [id]);
      await db.delete(tableName,
          where: '${SentenceFields.id} = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }
}
