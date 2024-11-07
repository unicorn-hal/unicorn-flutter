import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Entity/Chat/chat.dart';

/// ChatDataを監視するProvider
final chatDataProvider = ChangeNotifierProvider((ref) => ChatData());

class ChatData extends ChangeNotifier {
  static final ChatData _instance = ChatData._internal();
  factory ChatData() => _instance;
  ChatData._internal();

  List<Chat>? _data;

  List<Chat> get data => _data ?? [];

  void setChat(List<Chat> data) {
    _data = data;
    notifyListeners();
  }

  void addChat(Chat chat) {
    _data?.add(chat);
    notifyListeners();
  }
}
