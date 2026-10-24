import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/password_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('passwords.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE passwords (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            username TEXT NOT NULL,
            encryptedPassword TEXT NOT NULL,
            iv TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(PasswordEntry entry) async {
    final db = await instance.database;
    return await db.insert('passwords', entry.toMap());
  }

  Future<List<PasswordEntry>> getAll() async {
    final db = await instance.database;
    final result = await db.query('passwords', orderBy: 'title ASC');
    return result.map((json) => PasswordEntry.fromMap(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('passwords', where: 'id = ?', whereArgs: [id]);
  }
}