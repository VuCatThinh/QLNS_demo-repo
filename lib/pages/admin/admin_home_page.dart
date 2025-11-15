import 'package:flutter/material.dart';
import 'employee_list_page.dart';
import 'shift_page.dart';
import 'attendance_page.dart';
import 'salary_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang quản trị'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildModule(
              context,
              icon: Icons.people,
              label: 'Nhân viên',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmployeeListPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildModule(
              context,
              icon: Icons.schedule,
              label: 'Ca làm việc',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShiftPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildModule(
              context,
              icon: Icons.assignment,
              label: 'Chấm công',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AttendancePage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildModule(
              context,
              icon: Icons.attach_money,
              label: 'Lương',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SalaryPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModule(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity, // chiếm toàn bộ chiều ngang
      height: 80, // chiều cao mỗi module
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 36, color: Colors.blueAccent),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
