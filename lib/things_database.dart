import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String tableThings = 'things';
final String columnId = '_id';
final String columnName = 'name';
final String columnValue = 'value';
final String columnFilePath = 'path';

class ThingsItem {
  int id;
  String name;
  double value;
  File image;

  ThingsItem();

  //convenience constructor to create a ThingsItem object
  ThingsItem.fromMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.name = map[columnName];
    this.value = map[columnValue];
    this.image = map[columnFilePath] == null ? null : File(map[columnFilePath]);
  }

  //convenience method to create a Map from this object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnValue: value,
      columnFilePath: image == null ? null : image.path,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  void quickEdit({int id, String name, double value, File image}) {
    if (id != null) this.id = id;
    if (name != null) this.name = name;
    if (value != null) this.value = value;
    if (image != null) this.image = image;
  }

  @override
  toString() {
    return id.toString() + name + value.toString();
  }
}

class DatabaseHelper {
  //filename
  static final _databaseName = "things.db";

  //database version
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //only allow single open connection to database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  //open database
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableThings (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnValue REAL NOT NULL,
        $columnFilePath TEXT
      )
    ''');
  }

  //helper methods
  Future<int> insert(ThingsItem thing) async {
    Database db = await database;
    int id = await db.insert(tableThings, thing.toMap());
    return id;
  }

  Future<ThingsItem> queryThing(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableThings,
        columns: [columnId, columnName, columnValue, columnFilePath],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ThingsItem.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ThingsItem>> queryAllThings() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableThings,
        columns: [columnId, columnName, columnValue, columnFilePath]);
    List<ThingsItem> list = <ThingsItem>[];
    try {
      maps.forEach((element) => list.add(ThingsItem.fromMap(element)));
    } catch (e) {
      print(e);
    }
    return list;
  }

  void delete(ThingsItem thing) async {
    Database db = await database;
    db.delete(tableThings, where: "_id = ?", whereArgs: [thing.id]);
  }

  update({@required ThingsItem thing}) async {
    Database db = await database;

    int updateCount = await db.update(tableThings, thing.toMap(),
        where: '$columnId = ?', whereArgs: [thing.id]);
    return updateCount;
  }
  Future<int> countEntries() async {
    Database db = await database;
    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableThings'));
    return count;
  }
}