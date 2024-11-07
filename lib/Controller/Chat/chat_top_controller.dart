import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Service/Api/Chat/chat_api.dart';

class ChatTopController extends ControllerCore {
  ChatApi get _chatApi => ChatApi();

  ChatTopController();

  @override
  void initialize() {}
}
