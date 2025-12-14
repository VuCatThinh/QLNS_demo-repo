import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// 🔹 Desktop support
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init() {
    // Nếu chạy Desktop, khởi tạo FFI
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('employee_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    // Lấy đường dẫn database
    String dbPath;
    if (Platform.isAndroid || Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      dbPath = join(dir.path, fileName);
    } else {
      // Desktop
      final dbFolder = await getDatabasesPath();
      dbPath = join(dbFolder, fileName);
    }

    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(version: 1, onCreate: _createDB),
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Bảng nhân viên
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        position TEXT,
        salary REAL,
        email TEXT
      )
    ''');

    // Bảng chấm công
    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employeeId INTEGER NOT NULL,
        checkIn TEXT,
        checkOut TEXT
      )
    ''');
    // Bảng lương
    await db.execute('''
    CREATE TABLE salary (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      employeeId INTEGER NOT NULL,
      month INTEGER NOT NULL,
      year INTEGER NOT NULL,
      basicSalary REAL NOT NULL,
      totalHours REAL NOT NULL,
      bonus REAL DEFAULT 0,
      penalty REAL DEFAULT 0,
      totalSalary REAL NOT NULL
    )
  ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
