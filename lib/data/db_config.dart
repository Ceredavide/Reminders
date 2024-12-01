import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBConfig {
  static final DBConfig instance = DBConfig._init();
  static Database? _database;

  DBConfig._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        isCompleted INTEGER,
        dueDateTime TEXT,
        categoryId INTEGER,
        FOREIGN KEY (categoryId) REFERENCES categories(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');

    await db.execute('''
    INSERT INTO categories (name) VALUES ('Work')
  ''');
    await db.execute('''
    INSERT INTO categories (name) VALUES ('Personal')
  ''');
    await db.execute('''
    INSERT INTO categories (name) VALUES ('School')
  ''');
  }
}
