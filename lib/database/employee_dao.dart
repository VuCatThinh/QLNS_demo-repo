import 'package:sqflite/sqflite.dart';
import '../models/employee.dart';
import 'database_helper.dart';

class EmployeeDAO {
  final dbHelper = DatabaseHelper.instance;

  /// Lấy danh sách tất cả nhân viên
  Future<List<Employee>> getAllEmployees() async {
    final db = await dbHelper.database;
    final maps = await db.query('employees', orderBy: 'id DESC');

    return List.generate(maps.length, (i) {
      return Employee(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        position: maps[i]['position'] as String? ?? '',
        salary: maps[i]['salary'] is int
            ? (maps[i]['salary'] as int).toDouble()
            : maps[i]['salary'] as double? ?? 0,
        email: maps[i]['email'] as String? ?? '',
      );
    });
  }

  /// Thêm nhân viên
  Future<int> insertEmployee(Employee emp) async {
    final db = await dbHelper.database;
    return await db.insert('employees', emp.toMap());
  }

  /// Cập nhật nhân viên
  Future<int> updateEmployee(Employee emp) async {
    final db = await dbHelper.database;
    return await db.update(
      'employees',
      emp.toMap(),
      where: 'id = ?',
      whereArgs: [emp.id],
    );
  }

  /// Xóa nhân viên
  Future<int> deleteEmployee(int id) async {
    final db = await dbHelper.database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  /// Lấy 1 nhân viên theo ID (tuỳ chọn)
  Future<Employee?> getEmployeeById(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query('employees', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      final map = maps.first;
      return Employee(
        id: map['id'] as int,
        name: map['name'] as String,
        position: map['position'] as String? ?? '',
        salary: map['salary'] is int
            ? (map['salary'] as int).toDouble()
            : map['salary'] as double? ?? 0,
        email: map['email'] as String? ?? '',
      );
    } else {
      return null;
    }
  }
}
