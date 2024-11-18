import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/chatgpt_role.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_response.dart';

import '../../../../Constants/app_data_constants.dart';
import '../../../../Model/Entity/ChatGPT/chatgpt_chat.dart';
import '../../../../Model/Entity/ChatGPT/chatgpt_message.dart';
import '../../../../Model/Entity/User/user.dart';
import '../../../../Service/ChatGPT/chatgpt_service.dart';

class AiTextChatController extends ControllerCore {
  ChatGPTService get _chatGPTService => ChatGPTService();

  // コンストラクタ
  AiTextChatController();

  // 変数の定義
  late ValueNotifier<List<ChatGPTChat>> _chatList;

  // チャット用のコントローラー
  final TextEditingController messageController = TextEditingController();

  // スクロールコントローラー
  final ScrollController scrollController = ScrollController();

  // ユーザー情報
  final User _user = UserData().user!;

  // AIが思考中のフラグ
  bool _isThinking = false;

  // クイックアクションのリスト
  List<String> _quickActionList = [
    '持病の検索/登録をしたい',
    'おくすりリマインダーについて',
    'Myおくすりの登録をしたい',
    '医師との通話/通話予約について',
    '医師の検索がしたい',
  ];

  @override
  void initialize() {
    // チャットリストには初期メッセージとしてsystem命令文を追加
    _chatList = ValueNotifier([
      ChatGPTChat(
        created: DateTime.now(),
        message: ChatGPTMessage(
          content: '''
                    ${AppDataConstant.appDescription}

                    # ユーザーの情報を以下に記載します
                    名前: ${_user.firstName + _user.lastName}
                    生年月日: ${_user.birthDate}
                    身長: ${_user.bodyHeight}
                    体重: ${_user.bodyWeight}
                    性別: ${_user.gender}

                    ''',
          role: ChatGPTRole.system,
        ),
      ),
    ]);
  }

  ValueNotifier<List<ChatGPTChat>> get chatList => _chatList;

  /// AIのへのメッセージ送信
  Future<void> postMessage([String? quickAction]) async {
    // 思考中の場合は実行しない
    if (_isThinking) {
      Fluttertoast.showToast(msg: 'AIが思考中です');
      return;
    }
    // 追加するメッセージ
    late String postMessage;

    // クイックアクションがある場合はそれをメッセージとして送信
    if (quickAction != null) {
      postMessage = quickAction;
    } else {
      // テキストフィールドのバリデートチェック
      if (!_validateTextField()) {
        Fluttertoast.showToast(msg: 'メッセージを入力してください');
        return;
      }
      postMessage = messageController.text;

      // メッセージコントローラーのクリア
      messageController.text = '';
    }

    // 自分が送信したメッセージの追加
    ChatGPTChat newChat = ChatGPTChat(
      created: DateTime.now(),
      message: ChatGPTMessage(
        content: postMessage,
        role: ChatGPTRole.user,
      ),
    );

    // チャットリストに追加
    _chatList.value = [..._chatList.value, newChat];

    // フラグを思考中に変更
    _changeIsThinking();

    // AIへリストを送信
    final ChatGPTResponse? response = await _chatGPTService.postChatGPTMessage(
      _chatList.value.map((e) => e.message).toList(),
    );

    // フラグを思考終了に変更
    _changeIsThinking();

    late ChatGPTChat responseMessage;

    // 通信失敗などで返信がない場合はエラー内容をリストへ追加する
    if (response == null) {
      responseMessage = ChatGPTChat(
        created: DateTime.now(),
        message: ChatGPTMessage(
            role: ChatGPTRole.assistant,
            content: '通信が不安定で回答を取得できませんでした。\nもう一度お試しください。'),
      );
    } else {
      // AIからの返信メッセージの追加
      responseMessage = ChatGPTChat.fromJson(response.toJson());
    }

    _chatList.value = [..._chatList.value, responseMessage];
  }

  /// テキストフィールドのバリデートチェック
  bool _validateTextField() {
    final message = messageController.text;
    if (message.isEmpty) {
      return false;
    }
    return true;
  }

  /// AIが思考中のフラグを変更
  void _changeIsThinking() {
    _isThinking = !_isThinking;
  }

  bool get isThinking => _isThinking;

  List<String> get quickActionList => _quickActionList;
}
