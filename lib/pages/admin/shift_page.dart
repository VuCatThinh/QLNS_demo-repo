import 'package:flutter/material.dart';

class Shift {
  final String name;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Shift({required this.name, required this.startTime, required this.endTime});
}

class ShiftPage extends StatefulWidget {
  const ShiftPage({super.key});

  @override
  State<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
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
    Shift(
      name: 'Ca tối',
      startTime: const TimeOfDay(hour: 23, minute: 0),
      endTime: const TimeOfDay(hour: 7, minute: 0),
    ),
  ];

  void _deleteShift(int index) {
    setState(() {
      shifts.removeAt(index);
    });
  }

  void _editShift(int index) {
    _showShiftForm(shifts[index], (updatedShift) {
      setState(() {
        shifts[index] = updatedShift;
      });
    });
  }

  void _addShift() {
    _showShiftForm(null, (newShift) {
      setState(() {
        shifts.add(newShift);
      });
    });
  }

  void _showShiftForm(Shift? shift, Function(Shift) onSave) {
    final _nameController = TextEditingController(text: shift?.name ?? '');
    TimeOfDay? startTime = shift?.startTime;
    TimeOfDay? endTime = shift?.endTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(shift == null ? 'Thêm ca làm việc' : 'Sửa ca làm việc'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên ca'),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text(
                'Giờ bắt đầu: ${startTime?.format(context) ?? 'Chọn giờ'}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: startTime ?? const TimeOfDay(hour: 7, minute: 0),
                );
                if (picked != null) {
                  setState(() {
                    startTime = picked;
                  });
                }
              },
            ),
            ListTile(
              title: Text(
                'Giờ kết thúc: ${endTime?.format(context) ?? 'Chọn giờ'}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: endTime ?? const TimeOfDay(hour: 15, minute: 0),
                );
                if (picked != null) {
                  setState(() {
                    endTime = picked;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isEmpty ||
                  startTime == null ||
                  endTime == null)
                return;
              onSave(
                Shift(
                  name: _nameController.text.trim(),
                  startTime: startTime!,
                  endTime: endTime!,
                ),
              );
              Navigator.pop(context);
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
      appBar: AppBar(
        title: const Text('Ca làm việc'),
        actions: [
          IconButton(
            onPressed: _addShift,
            icon: const Icon(Icons.add),
            tooltip: 'Thêm ca làm việc',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: shifts.length,
        itemBuilder: (context, index) {
          final shift = shifts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              title: Text(
                shift.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Từ ${shift.startTime.format(context)} - ${shift.endTime.format(context)}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _editShift(index),
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  ),
                  IconButton(
                    onPressed: () => _deleteShift(index),
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
