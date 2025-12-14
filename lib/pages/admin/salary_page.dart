import 'package:flutter/material.dart';
import '../../database/salary_dao.dart';
import '../../database/employee_dao.dart';
import '../../models/employee.dart';
import '../../models/salary.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({super.key});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  final EmployeeDAO _employeeDAO = EmployeeDAO();
  final SalaryDAO _salaryDAO = SalaryDAO();

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  Map<int, Salary?> salaryMap = {};

  @override
  void initState() {
    super.initState();
    _loadSalaries();
  }

  Future<void> _loadSalaries() async {
    final employees = await _employeeDAO.getAllEmployees();
    final Map<int, Salary?> map = {};
    for (var emp in employees) {
      final salary = await _salaryDAO.getSalary(
        emp.id!,
        selectedMonth,
        selectedYear,
      );
      map[emp.id!] = salary;
    }
    setState(() {
      salaryMap = map;
    });
  }

  /// Tính lương dựa trên lương cơ bản/giờ của nhân viên
  Future<void> _calculateSalary(Employee emp) async {
    final salary = await _salaryDAO.calculateSalaryFromEmployee(
      emp.id!,
      selectedMonth,
      selectedYear,
    );
    await _salaryDAO.saveSalary(salary);
    await _loadSalaries();
  }

  Future<void> _updateBonusPenalty(Salary salary) async {
    final bonusController = TextEditingController(
      text: salary.bonus.toString(),
    );
    final penaltyController = TextEditingController(
      text: salary.penalty.toString(),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật thưởng/phạt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bonusController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Thưởng'),
            ),
            TextField(
              controller: penaltyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Phạt'),
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
              final bonus = double.tryParse(bonusController.text) ?? 0;
              final penalty = double.tryParse(penaltyController.text) ?? 0;
              await _salaryDAO.updateBonusPenalty(salary.id!, bonus, penalty);
              Navigator.pop(context);
              await _loadSalaries();
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý lương')),
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
              final salary = salaryMap[emp.id!];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(emp.name),
                  subtitle: salary == null
                      ? const Text('Chưa tính lương')
                      : Text(
                          'Tổng giờ: ${salary.totalHours.toStringAsFixed(2)}h\n'
                          'Lương cơ bản/giờ: ${salary.basicSalary.toStringAsFixed(0)} VND\n'
                          'Thưởng: ${salary.bonus.toStringAsFixed(0)} | Phạt: ${salary.penalty.toStringAsFixed(0)}\n'
                          'Tổng lương: ${salary.totalSalary.toStringAsFixed(0)} VND',
                        ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => _calculateSalary(emp),
                        child: const Text('Tính lương'),
                      ),
                      const SizedBox(width: 8),
                      if (salary != null)
                        ElevatedButton(
                          onPressed: () => _updateBonusPenalty(salary),
                          child: const Text('Cập nhật'),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
