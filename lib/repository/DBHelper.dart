import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trixie/domain/DomainBase.dart';
import 'package:flutter/services.dart' show rootBundle;

abstract class DBHelper<T extends DomainBase> {
  static const String DATABASE_NAME = "test.db";
  static const int VERSION = 1;

  static Database _db;
  String tableName;

  DBHelper(String tableName) {
    this.tableName = tableName;
    db;
  }

  Future<Database> get db async {
    if(_db == null)
      _db = await initDb();

    return _db;
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DATABASE_NAME);
    var theDb = await openDatabase(path, version: VERSION, onCreate: _onCreate);

    return theDb;
  }

  // Creating database
  void _onCreate(Database db, int version) async {
    var text = await rootBundle.loadString("assets/sql_$VERSION.sql");
    var queries = text.split("\n").where((s) => s.isNotEmpty).toList();
    queries.forEach((q) { db.execute(q); });
    print("Database created!");
  }

  Future<int> insert(T item) async {
    var database = await db;
    return await database.insert(tableName, item.toMap());
  }

  Future<List> insertAll(List<T> items) async {
    var database = await db;
    var batch = database.batch();
    items.forEach((i) => batch.insert(tableName, i.toMap()));
    return batch.commit();
  }

  Future<int> update(T item) async {
    var database = await db;
    return await database.update(tableName, item.toMap(), where: "id = ?", whereArgs: [item.id]);
  }

  Future<int> delete(int id) async {
    var database = await db;
    return await database.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<List<T>> getAll() async {
    var database = await db;
    List<Map> list = await database.query(tableName);
    return list.map((t) => fromMap(t)).toList();
  }


  Future<int> clear() async {
    var database = await db;
    return await database.delete(tableName);
  }

  //TODO: This should be moved to DomainBase. 
  //I didn't find how to instance or use generics properly with flutter
  //Another option is instance an mapper together with database (instead adding this responsability in domain)
  T fromMap(Map item);
}