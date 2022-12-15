import 'dart:collection';
import 'dart:math';

import 'package:path/path.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/model/sentence.dart';
import 'package:speekup_v2/model/user.dart';
import 'package:speekup_v2/db/user_table.dart';
import 'package:sqflite/sqflite.dart';

String tableUsers = "users";
String tableCategories = "categories";
String tableSentences = "sentences";
String tableSentenceCategory = "sentence_category";

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

    deleteDatabase('speekup_test.db');
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    const String intType = 'INTEGER NOT NULL';
    const String textType = 'TEXT NOT NULL';

    //Create table user
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableUsers (
          ${UserFields.id} $idType,
          ${UserFields.username} $textType,
          ${UserFields.fullname} $textType,
          ${UserFields.email} $textType,
          ${UserFields.password} $textType
        )
        ''');

      //Create table category 
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableCategories (
          ${CategoryFields.id} $idType,
          ${CategoryFields.name} $textType,
          ${CategoryFields.isDeletable} $intType,
          ${CategoryFields.username} $intType
        )
        ''');
      
      //Create table sentence 
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableSentences (
          ${SentenceFields.id} $idType,
          ${SentenceFields.word} $textType,
          ${SentenceFields.isDeletable} $intType,
          ${SentenceFields.frequency} $intType,
          ${SentenceFields.description} TEXT
        )
        ''');

      //Sentence_category table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableSentenceCategory (
          id $idType,
          categoryID $intType,
          sentenceID $intType
        )
        ''');

  }

  Future close() async {
    final db = await instance.database;
    db?.close();
  }

}
