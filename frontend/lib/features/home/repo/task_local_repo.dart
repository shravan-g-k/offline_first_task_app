import 'package:frontend/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalRepo {
  String tableName = 'tasks';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(
            'ALTER TABLE $tableName ADD COLUMN isSynced INTEGER NOT NULL',
          );
        }
      },
      onCreate: (db, version) async {
        await db.execute('''
         CREATE TABLE $tableName(
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              description TEXT NOT NULL,
              uid TEXT NOT NULL,
              hexColor TEXT NOT NULL,
              dueAt TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              isSynced INTEGER NOT NULL
        )
      ''');
      },
    );
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [task.id]);
    await db.insert(tableName, task.toMap());
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();

    for (final task in tasks) {
      batch.insert(
        tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getTask() async {
    final db = await database;
    final result = await db.query(tableName);
    List<TaskModel> tasks = [];
    if (result.isNotEmpty) {
      for (final ele in result) {
        tasks.add(TaskModel.fromMap(ele));
      }
      return tasks;
    }

    return [];
  }

  Future<List<TaskModel>> getUnsyncedTasks() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: "isSynced = ?",
      whereArgs: [0],
    );
    List<TaskModel> tasks = [];
    if (result.isNotEmpty) {
      for (final ele in result) {
        tasks.add(TaskModel.fromMap(ele));
      }
      return tasks;
    }

    return [];
  }

   Future<void> updateRowValue(String id, int newValue) async {
    final db = await database;
    await db.update(
      tableName,
      {'isSynced': newValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
