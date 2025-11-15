import 'package:flutter/material.dart';
import 'employee_list_page.dart';

class Salary {
  final Employee employee;
  final double baseSalary;
  int daysWorked;

  Salary({
    required this.employee,
    required this.baseSalary,
    this.daysWorked = 0,
  });

  double get totalSalary => baseSalary * daysWorked;
}

class SalaryPage extends StatefulWidget {
  const SalaryPage({super.key});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  // Dữ liệu mẫu
  List<Salary> salaries = [
    Salary(
      employee: Employee(
        name: 'Nguyễn Văn A',
        position: 'Quản lý',
        avatarUrl: '',
      ),
      baseSalary: 300000,
    ),
    Salary(
      employee: Employee(
        name: 'Trần Thị B',
        position: 'Nhân viên pha chế',
        avatarUrl: '',
      ),
      baseSalary: 200000,
    ),
    Salary(
      employee: Employee(name: 'Lê Văn C', position: 'Thu ngân', avatarUrl: ''),
      baseSalary: 220000,
    ),
  ];

  void _incrementDays(int index) {
    setState(() {
      salaries[index].daysWorked += 1;
    });
  }

  void _decrementDays(int index) {
    setState(() {
      if (salaries[index].daysWorked > 0) salaries[index].daysWorked -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý lương')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: salaries.length,
        itemBuilder: (context, index) {
          final salary = salaries[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(salary.employee.avatarUrl),
                radius: 28,
              ),
              title: Text(
                salary.employee.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chức vụ: ${salary.employee.position}'),
                  Text(
                    'Lương cơ bản: ${salary.baseSalary.toStringAsFixed(0)} VNĐ',
                  ),
                  Text('Ngày công: ${salary.daysWorked} ngày'),
                  Text(
                    'Tổng lương: ${salary.totalSalary.toStringAsFixed(0)} VNĐ',
                  ),
                ],
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _incrementDays(index),
                    icon: const Icon(Icons.add, color: Colors.green),
                  ),
                  IconButton(
                    onPressed: () => _decrementDays(index),
                    icon: const Icon(Icons.remove, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
