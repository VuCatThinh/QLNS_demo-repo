import 'package:flutter/material.dart';
import 'employee_list_page.dart';
import 'shift_page.dart';

class Attendance {
  final Employee employee;
  final Shift shift;
  bool isPresent;

  Attendance({
    required this.employee,
    required this.shift,
    this.isPresent = false,
  });
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // Dữ liệu mẫu
  List<Employee> employees = [
    Employee(name: 'Nguyễn Văn A', position: 'Quản lý', avatarUrl: ''),
    Employee(name: 'Trần Thị B', position: 'Nhân viên pha chế', avatarUrl: ''),
    Employee(name: 'Lê Văn C', position: 'Thu ngân', avatarUrl: ''),
  ];

  List<Shift> shifts = [
    Shift(
      name: 'Ca sáng',
      startTime: const TimeOfDay(hour: 7, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 0),
    ),
    Shift(
      name: 'Ca chiều',
      startTime: const TimeOfDay(hour: 15, minute: 0),
      endTime: const TimeOfDay(hour: 23, minute: 0),
    ),
  ];

  List<Attendance> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    // Tạo dữ liệu chấm công mẫu: tất cả nhân viên, ca sáng
    attendanceRecords = employees
        .map((e) => Attendance(employee: e, shift: shifts[0]))
        .toList();
  }

  void _toggleAttendance(int index) {
    setState(() {
      attendanceRecords[index].isPresent = !attendanceRecords[index].isPresent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chấm công')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: attendanceRecords.length,
        itemBuilder: (context, index) {
          final record = attendanceRecords[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(record.employee.avatarUrl),
                radius: 28,
              ),
              title: Text(
                record.employee.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(record.shift.name),
              trailing: ElevatedButton(
                onPressed: () => _toggleAttendance(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: record.isPresent ? Colors.green : Colors.red,
                ),
                child: Text(
                  record.isPresent ? 'Có mặt' : 'Vắng',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
