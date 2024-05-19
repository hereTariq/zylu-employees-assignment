class Employee {
  int? id;
  String? name;
  DateTime? joiningDate;
  bool? isActive;

  Employee({this.id, this.name, this.joiningDate, this.isActive});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      joiningDate: _parseDateTime(json['joiningDate']),
      isActive: json['isActive'],
    );
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString == null) return null;
    try {
      // Manually parse the date string to ensure compatibility with different formats
      final parts = dateString.split('T')[0].split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }
}
