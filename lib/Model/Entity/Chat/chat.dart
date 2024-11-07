import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_doctor.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_request.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_user.dart';

class Chat {
  final String chatId;
  final ChatDoctor doctor;
  final ChatUser user;
  final String latestMessageText;
  final DateTime latestMessageSentAt;

  Chat({
    required this.chatId,
    required this.doctor,
    required this.user,
    required this.latestMessageText,
    required this.latestMessageSentAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatID'],
      doctor: ChatDoctor.fromJson(json['doctor']),
      user: ChatUser.fromJson(json['user']),
      latestMessageText: json['latestMessageText'],
      latestMessageSentAt: DateTime.parse(json['latestMessageSentAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatID': chatId,
      'doctor': doctor.toJson(),
      'user': user.toJson(),
      'latestMessageText': latestMessageText,
      'latestMessageSentAt':
          DateFormat('yyyy-MM-dd').format(latestMessageSentAt),
    };
  }

  ChatRequest toRequest() {
    return ChatRequest.fromJson({
      'doctorID': doctor.doctorId,
      'userID': user.userId,
    });
  }
}
