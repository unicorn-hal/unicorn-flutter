import 'package:intl/intl.dart';

class HospitalNews {
  final String id;
  final String hospitalId;
  final String hospitalName;
  final String title;
  final String content;
  final String? imageUrl;
  final String relatedUrl;
  final DateTime postedDate;

  HospitalNews({
    required this.id,
    required this.hospitalId,
    required this.hospitalName,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.relatedUrl,
    required this.postedDate,
  });

  factory HospitalNews.fromJson(Map<String, dynamic> json) {
    return HospitalNews(
      id: json['hospitalNewsID'],
      hospitalId: json['hospitalID'],
      hospitalName: json['hospitalName'],
      title: json['title'],
      content: json['contents'],
      imageUrl: json['noticeImageUrl'],
      relatedUrl: json['relatedUrl'],
      postedDate: DateTime.parse(json['postedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hospitalNewsID': id,
      'hospitalID': hospitalId,
      'hospitalName': hospitalName,
      'title': title,
      'contents': content,
      'noticeImageUrl': imageUrl,
      'relatedUrl': relatedUrl,
      'postedDate': DateFormat('yyyy-MM-ddTHH:mm:ss').format(postedDate),
    };
  }
}
