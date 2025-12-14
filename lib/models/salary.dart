class Salary {
  int? id;
  int employeeId;
  int month;
  int year;
  double basicSalary;
  double totalHours;
  double bonus;
  double penalty;
  double totalSalary;

  Salary({
    this.id,
    required this.employeeId,
    required this.month,
    required this.year,
    required this.basicSalary,
    required this.totalHours,
    this.bonus = 0,
    this.penalty = 0,
    required this.totalSalary,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'employeeId': employeeId,
      'month': month,
      'year': year,
      'basicSalary': basicSalary,
      'totalHours': totalHours,
      'bonus': bonus,
      'penalty': penalty,
      'totalSalary': totalSalary,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Salary.fromMap(Map<String, dynamic> map) {
    return Salary(
      id: map['id'] as int?,
      employeeId: map['employeeId'] as int,
      month: map['month'] as int,
      year: map['year'] as int,
      basicSalary: map['basicSalary'] as double,
      totalHours: map['totalHours'] as double,
      bonus: map['bonus'] as double? ?? 0,
      penalty: map['penalty'] as double? ?? 0,
      totalSalary: map['totalSalary'] as double,
    );
  }
}
