import 'package:flutter/material.dart';
import 'employee_list_page.dart';
import 'attendance_page.dart';
import 'salary_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ứng dụng quản lý nhân sự')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuButton(
              title: 'Quản lý nhân viên',
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmployeeListPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            MenuButton(
              title: 'Chấm công nhân viên',
              icon: Icons.access_time,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AttendanceManagementPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            MenuButton(
              title: 'Quản lý lương',
              icon: Icons.attach_money,
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
}

/// Widget nút menu chính
class MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 30),
        label: Text(title, style: const TextStyle(fontSize: 20)),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
