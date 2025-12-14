class Attendance {
  int? id;
  int employeeId;
  DateTime? checkIn;
  DateTime? checkOut;

  Attendance({this.id, required this.employeeId, this.checkIn, this.checkOut});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'employeeId': employeeId,
      'checkIn': checkIn?.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'] as int,
      employeeId: map['employeeId'] as int,
      checkIn: map['checkIn'] != null ? DateTime.parse(map['checkIn']) : null,
      checkOut: map['checkOut'] != null
          ? DateTime.parse(map['checkOut'])
          : null,
    );
  }
}
