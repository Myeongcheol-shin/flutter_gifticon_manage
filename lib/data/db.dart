import 'dart:async';
import 'dart:io';
import 'package:flutter_gifticon_box/data/db_card.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<int> add(DbCard dbCard) async {
    Database db = await instance.database;
    return await db.insert('DbCard', dbCard.toMap());
  }

  Future<List<DbCard>> getDbCard() async {
    Database db = await instance.database;
    var dbCards = await db.query("DbCard", orderBy: 'name');
    List<DbCard> dbCardList = dbCards.isNotEmpty
        ? dbCards.map((e) => DbCard.fromMap(e)).toList()
        : [];
    return dbCardList;
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('DbCard', where: 'id = ?', whereArgs: [id]);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE DbCard(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      info TEXT NOT NULL,
      color INTEGER NOT NULL,
      couponNumber TEXT,
      file TEXT
    )
    ''');
  }
}
