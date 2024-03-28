import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

import 'note_model.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'notes';
  static final _columnId = 'id';
  static final _columnTitle = 'title';
  static final _columnContent = 'content';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, 'notes.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $_columnId INTEGER PRIMARY KEY,
        $_columnTitle TEXT,
        $_columnContent TEXT
      )
    ''');
  }

  Future<int> insert(Note note) async {
    Database db = await instance.database;
    return await db.insert(_tableName, note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<void> update(Note note) async {
    Database db = await instance.database;
    await db.update(
      _tableName,
      note.toMap(),
      where: '$_columnId = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> delete(int id) async {
    Database db = await instance.database;
    await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }
}
