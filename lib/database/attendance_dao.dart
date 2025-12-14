import 'package:sqflite/sqflite.dart';
import '../models/attendance.dart';
import 'database_helper.dart';

class AttendanceDAO {
  final dbHelper = DatabaseHelper.instance;

  /// Ghi nhận giờ vào (check-in)
  Future<int> checkIn(int employeeId) async {
    final db = await dbHelper.database;
    final attendance = Attendance(
      employeeId: employeeId,
      checkIn: DateTime.now(),
    );
    return await db.insert('attendance', attendance.toMap());
  }

  /// Ghi nhận giờ ra (check-out)
  Future<int> checkOut(int attendanceId) async {
    final db = await dbHelper.database;
    return await db.update(
      'attendance',
      {'checkOut': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [attendanceId],
    );
  }

  /// Lấy danh sách chấm công của 1 nhân viên
  Future<List<Attendance>> getAttendanceByEmployee(int employeeId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'attendance',
      where: 'employeeId = ?',
      whereArgs: [employeeId],
      orderBy: 'checkIn DESC',
    );

    return maps.map((map) => Attendance.fromMap(map)).toList();
  }

  /// Lấy danh sách chấm công ngày hôm nay của 1 nhân viên
  Future<Attendance?> getTodayAttendance(int employeeId) async {
    final db = await dbHelper.database;
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final maps = await db.query(
      'attendance',
      where: 'employeeId = ? AND checkIn >= ? AND checkIn < ?',
      whereArgs: [employeeId, start.toIso8601String(), end.toIso8601String()],
    );

    if (maps.isNotEmpty) {
      return Attendance.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /// Cập nhật check-in và check-out
  Future<int> updateAttendance(
    int id,
    DateTime? checkIn,
    DateTime? checkOut,
  ) async {
    final db = await dbHelper.database;
    return await db.update(
      'attendance',
      {
        'checkIn': checkIn?.toIso8601String(),
        'checkOut': checkOut?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Xóa chấm công
  Future<int> deleteAttendance(int id) async {
    final db = await dbHelper.database;
    return await db.delete('attendance', where: 'id = ?', whereArgs: [id]);
  }
}
