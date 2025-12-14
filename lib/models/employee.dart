class Employee {
  int? id;
  String name;
  String position;
  double salary;
  String email;

  Employee({
    this.id,
    required this.name,
    required this.position,
    required this.salary,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'position': position,
      'salary': salary,
      'email': email,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
