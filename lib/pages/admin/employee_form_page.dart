import 'package:flutter/material.dart';
import '/database/employee_dao.dart';
import '/models/employee.dart';

class EmployeeFormPage extends StatefulWidget {
  final Employee? employee;

  const EmployeeFormPage({super.key, this.employee});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final EmployeeDAO _employeeDAO = EmployeeDAO();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _positionController.text = widget.employee!.position;
      _salaryController.text = widget.employee!.salary.toString();
      _emailController.text = widget.employee!.email;
    }
  }

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    final employee = Employee(
      id: widget.employee?.id,
      name: _nameController.text,
      position: _positionController.text,
      salary: double.parse(_salaryController.text),
      email: _emailController.text,
    );

    if (widget.employee == null) {
      await _employeeDAO.insertEmployee(employee);
    } else {
      await _employeeDAO.updateEmployee(employee);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.employee == null ? 'Thêm nhân viên' : 'Cập nhật nhân viên',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên nhân viên'),
                validator: (value) =>
                    value!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: 'Chức vụ'),
              ),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Lương cơ bản'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveEmployee,
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
