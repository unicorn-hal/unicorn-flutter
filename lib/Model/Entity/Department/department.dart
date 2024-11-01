class Department {
  final String departmentId;
  final String departmentName;

  Department({
    required this.departmentId,
    required this.departmentName,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      departmentId: json['departmentID'],
      departmentName: json['departmentName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departmentID': departmentId,
      'departmentName': departmentName,
    };
  }
}
