import 'package:flutter/material.dart';

class Employee {
  String name;
  String position;
  String avatarUrl;

  Employee({
    required this.name,
    required this.position,
    required this.avatarUrl,
  });
}

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Employee> employees = [
    Employee(name: 'Nguyễn Văn A', position: 'Quản lý', avatarUrl: ''),
    Employee(name: 'Trần Thị B', position: 'Nhân viên pha chế', avatarUrl: ''),
    Employee(name: 'Lê Văn C', position: 'Thu ngân', avatarUrl: ''),
  ];

  void _deleteEmployee(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn xóa nhân viên này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() => employees.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editEmployee(int index) {
    final emp = employees[index];
    final nameController = TextEditingController(text: emp.name);
    final positionController = TextEditingController(text: emp.position);
    final avatarController = TextEditingController(text: emp.avatarUrl);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Chỉnh sửa nhân viên'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên'),
              ),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(labelText: 'Chức vụ'),
              ),
              TextField(
                controller: avatarController,
                decoration: const InputDecoration(labelText: 'URL ảnh'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                emp.name = nameController.text.trim();
                emp.position = positionController.text.trim();
                emp.avatarUrl = avatarController.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Lưu',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _addEmployee() {
    final nameController = TextEditingController();
    final positionController = TextEditingController();
    final avatarController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thêm nhân viên'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên'),
              ),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(labelText: 'Chức vụ'),
              ),
              TextField(
                controller: avatarController,
                decoration: const InputDecoration(labelText: 'URL ảnh'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  positionController.text.isNotEmpty &&
                  avatarController.text.isNotEmpty) {
                setState(() {
                  employees.add(
                    Employee(
                      name: nameController.text.trim(),
                      position: positionController.text.trim(),
                      avatarUrl: avatarController.text.trim(),
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Thêm',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách nhân viên'),
        actions: [
          IconButton(
            onPressed: _addEmployee,
            icon: const Icon(Icons.add),
            tooltip: 'Thêm nhân viên',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final emp = employees[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(emp.avatarUrl),
                radius: 28,
              ),
              title: Text(
                emp.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(emp.position),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _editEmployee(index),
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  ),
                  IconButton(
                    onPressed: () => _deleteEmployee(index),
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
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
