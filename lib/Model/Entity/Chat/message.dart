import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message_request.dart';

class Message {
  final String messageId;
  final String chatId;
  final String senderId;
  final String firstName;
  final String lastName;
  final String? iconImageUrl;
  final String content;
  final DateTime sentAt;

  Message({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.firstName,
    required this.lastName,
    this.iconImageUrl,
    required this.content,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageID'],
      chatId: json['chatID'],
      senderId: json['senderID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      iconImageUrl: json['iconImageUrl'],
      content: json['content'],
      sentAt: DateTime.parse(json['sentAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageID': messageId,
      'chatID': chatId,
      'senderID': senderId,
      'firstName': firstName,
      'lastName': lastName,
      'iconImageUrl': iconImageUrl,
      'content': content,
      'sentAt': DateFormat('yyyy-MM-dd').format(sentAt),
    };
  }

  MessageRequest toRequest() {
    return MessageRequest.fromJson(toJson());
  }
}
