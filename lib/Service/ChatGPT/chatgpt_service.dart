import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_message.dart';
import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_response.dart';

class ChatGPTService {
  final String _endpoint = 'https://api.openai.com/v1/chat/completions';

  Future<ChatGPTResponse?> postChatGPTMessage(List<ChatGPTMessage> body) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(_endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['CHATGPI_API_KEY']}',
        },
        body: jsonEncode(
          <String, dynamic>{
            'model': 'gpt-4',
            'messages': body.map((e) => e.toJson()).toList(),
            'temperature': 0.7,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get response');
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      return ChatGPTResponse.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
