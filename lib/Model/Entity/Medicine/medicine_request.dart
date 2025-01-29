import 'package:unicorn_flutter/Model/Entity/Medicine/reminder.dart';

class MedicineRequest {
  final String medicineName;
  final int count;
  final int quantity;
  final int dosage;
  final List<Reminder> reminders;

  MedicineRequest({
    required this.medicineName,
    required this.count,
    required this.quantity,
    required this.dosage,
    required this.reminders,
  });

  factory MedicineRequest.fromJson(Map<String, dynamic> json) {
    return MedicineRequest(
      medicineName: json['medicineName'],
      count: json['count'],
      quantity: json['quantity'],
      dosage: json['dosage'],
      reminders:
          (json['reminders'] as List).map((e) => Reminder.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'count': count,
      'quantity': quantity,
      'dosage': dosage,
      'reminders': reminders.map((e) => e.toJson()).toList(),
    };
  }
}
