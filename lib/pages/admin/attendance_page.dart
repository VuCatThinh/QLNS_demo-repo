import 'package:flutter/material.dart';
import '../../database/attendance_dao.dart';
import '../../database/employee_dao.dart';
import '../../models/employee.dart';
import '../../models/attendance.dart';

class AttendanceManagementPage extends StatefulWidget {
  const AttendanceManagementPage({super.key});

  @override
  State<AttendanceManagementPage> createState() =>
      _AttendanceManagementPageState();
}

class _AttendanceManagementPageState extends State<AttendanceManagementPage> {
  final EmployeeDAO _employeeDAO = EmployeeDAO();
  final AttendanceDAO _attendanceDAO = AttendanceDAO();

  Map<int, List<Attendance>> attendanceMap = {};

  @override
  void initState() {
    super.initState();
    _loadAllAttendance();
  }

  Future<void> _loadAllAttendance() async {
    final employees = await _employeeDAO.getAllEmployees();
    final Map<int, List<Attendance>> map = {};
    for (var emp in employees) {
      final attList = await _attendanceDAO.getAttendanceByEmployee(emp.id!);
      map[emp.id!] = attList;
    }
    setState(() {
      attendanceMap = map;
    });
  }

  Future<void> _checkIn(Employee emp) async {
    await _attendanceDAO.checkIn(emp.id!);
    await _loadAllAttendance();
  }

  Future<void> _checkOut(Attendance att) async {
    if (att.checkOut == null) {
      await _attendanceDAO.checkOut(att.id!);
      await _loadAllAttendance();
    }
  }

  Future<void> _editAttendance(Attendance att) async {
    final checkInController = TextEditingController(
      text: att.checkIn?.toIso8601String() ?? '',
    );
    final checkOutController = TextEditingController(
      text: att.checkOut?.toIso8601String() ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Chỉnh sửa chấm công'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: checkInController,
              decoration: const InputDecoration(
                labelText: 'Check-in (YYYY-MM-DD HH:MM)',
              ),
            ),
            TextField(
              controller: checkOutController,
              decoration: const InputDecoration(
                labelText: 'Check-out (YYYY-MM-DD HH:MM)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newCheckIn = DateTime.tryParse(
                checkInController.text.trim(),
              );
              final newCheckOut = DateTime.tryParse(
                checkOutController.text.trim(),
              );
              if (newCheckIn != null) {
                await _attendanceDAO.updateAttendance(
                  att.id!,
                  newCheckIn,
                  newCheckOut,
                );
                await _loadAllAttendance();
                Navigator.pop(context);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAttendance(int id) async {
    await _attendanceDAO.deleteAttendance(id);
    await _loadAllAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý chấm công')),
      body: FutureBuilder<List<Employee>>(
        future: _employeeDAO.getAllEmployees(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final employees = snapshot.data!;
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final emp = employees[index];
              final attList = attendanceMap[emp.id!] ?? [];

              return ExpansionTile(
                title: Text(emp.name),
                subtitle: Text(emp.position),
                children: [
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _checkIn(emp),
                        icon: const Icon(Icons.login),
                        label: const Text('Check-in'),
                      ),
                      const SizedBox(width: 10),
                      if (attList.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () => _checkOut(attList.last),
                          icon: const Icon(Icons.logout),
                          label: const Text('Check-out'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ...attList.map(
                    (att) => ListTile(
                      title: Text(
                        'Check-in: ${att.checkIn?.toString() ?? "-"} | Check-out: ${att.checkOut?.toString() ?? "-"}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editAttendance(att),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteAttendance(att.id!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
