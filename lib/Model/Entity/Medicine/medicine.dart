import 'package:unicorn_flutter/Model/Entity/Medicine/medicine_request.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/reminder.dart';

class Medicine {
  final String medicineId;
  final String medicineName;
  final int count;
  final int quantity;
  final List<Reminder> reminders;

  Medicine({
    required this.medicineId,
    required this.medicineName,
    required this.count,
    required this.quantity,
    required this.reminders,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      medicineId: json['medicineID'],
      medicineName: json['medicineName'],
      count: json['count'],
      quantity: json['quantity'],
      reminders:
          (json['reminders'] as List).map((e) => Reminder.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineID': medicineId,
      'medicineName': medicineName,
      'count': count,
      'quantity': quantity,
      'reminders': reminders.map((e) => e.toJson()).toList(),
    };
  }

  MedicineRequest toRequest() {
    return MedicineRequest.fromJson(toJson());
  }
}
