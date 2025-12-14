import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/attendance_dao.dart';
import '../models/salary.dart';
import '../models/attendance.dart';
import '../models/employee.dart';
import 'employee_dao.dart';

class SalaryDAO {
  final dbHelper = DatabaseHelper.instance;
  final attendanceDAO = AttendanceDAO();
  final EmployeeDAO _employeeDAO = EmployeeDAO();

  /// Tính tổng giờ làm việc trong tháng (tất cả các ca)
  Future<double> calculateTotalHours(
    int employeeId,
    int month,
    int year,
  ) async {
    final attendances = await attendanceDAO.getAttendanceByEmployee(employeeId);
    double totalHours = 0;

    for (var att in attendances) {
      if (att.checkIn != null && att.checkOut != null) {
        if (att.checkIn!.month == month && att.checkIn!.year == year) {
          final duration = att.checkOut!.difference(att.checkIn!);
          totalHours += duration.inMinutes / 60.0;
        }
      }
    }

    return totalHours;
  }

  /// Tính lương dựa trên tổng giờ làm và lương cơ bản/giờ
  Future<Salary> calculateSalary(
    int employeeId,
    int month,
    int year,
    double basicSalaryPerHour, {
    double bonus = 0,
    double penalty = 0,
  }) async {
    final totalHours = await calculateTotalHours(employeeId, month, year);
    final totalSalary = totalHours * basicSalaryPerHour + bonus - penalty;

    return Salary(
      employeeId: employeeId,
      month: month,
      year: year,
      basicSalary: basicSalaryPerHour,
      totalHours: totalHours,
      bonus: bonus,
      penalty: penalty,
      totalSalary: totalSalary,
    );
  }

  /// Tính lương từ bảng Employee (dùng Employee.salary làm lương cơ bản/giờ)
  Future<Salary> calculateSalaryFromEmployee(
    int employeeId,
    int month,
    int year,
  ) async {
    final employee = await _employeeDAO.getEmployeeById(employeeId);
    if (employee == null) {
      throw Exception('Không tìm thấy nhân viên với ID: $employeeId');
    }
    return calculateSalary(employeeId, month, year, employee.salary);
  }

  /// Lưu hoặc cập nhật lương
  Future<int> saveSalary(Salary salary) async {
    final db = await dbHelper.database;
    return await db.insert(
      'salary',
      salary.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Lấy lương theo nhân viên và tháng
  Future<Salary?> getSalary(int employeeId, int month, int year) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'salary',
      where: 'employeeId = ? AND month = ? AND year = ?',
      whereArgs: [employeeId, month, year],
    );
    if (maps.isNotEmpty) {
      return Salary.fromMap(maps.first);
    }
    return null;
  }

  /// Cập nhật thưởng/phạt và tính lại tổng lương
  Future<int> updateBonusPenalty(int id, double bonus, double penalty) async {
    final db = await dbHelper.database;

    // Lấy salary hiện tại
    final maps = await db.query('salary', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return 0;
    final currentSalary = Salary.fromMap(maps.first);

    // Tính lại tổng lương
    final newTotalSalary =
        currentSalary.totalHours * currentSalary.basicSalary + bonus - penalty;

    return await db.update(
      'salary',
      {'bonus': bonus, 'penalty': penalty, 'totalSalary': newTotalSalary},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
