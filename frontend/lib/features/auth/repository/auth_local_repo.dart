import 'package:frontend/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AuthLocalRepo {
  String tableName = 'users';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'auth.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $tableName (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          token TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');
    });
  }

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(
      tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    final result = await db.query(tableName, limit: 1);
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }

    return null;
  }
}
