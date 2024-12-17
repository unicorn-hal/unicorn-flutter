import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';

import '../../../Model/Entity/Chat/message.dart';
import '../../../Model/Entity/Doctor/doctor.dart';

class MessageReportService {
  /// コメント通報
  Future<int> reportMessage({
    required Doctor doctor,
    required Message message,
  }) async {
    try {
      final webhookUrl = dotenv.env['DISCORD_WEBHOOK_URL']!;
      final url = Uri.https('discord.com', webhookUrl);
      final headers = {'Content-Type': 'application/json'};

      final embed = {
        'title': '⚠ Unicorn Report ⚠',
        'color': 5814783,
        'fields': [
          {'name': '🔷ChatID', 'value': message.chatId, 'inline': false},
          {'name': '🔶MessageID', 'value': message.messageId, 'inline': false},
          {
            'name': '👤通報したユーザー',
            'value':
                '${UserData().user!.lastName + UserData().user!.firstName}[${UserData().user!.userId}]',
            'inline': false
          },
          {
            'name': '🥼通報された医者',
            'value':
                '${doctor.lastName + doctor.firstName}[${doctor.doctorId}]',
            'inline': false
          },
          {'name': '📝内容', 'value': message.content, 'inline': false}
        ],
        'footer': {
          'text': 'Unicorn Report System',
        },
      };

      final body = jsonEncode({
        'username': 'Unicorn',
        'avatar_url': '',
        'embeds': [embed],
      });

      http.Response response =
          await http.post(url, headers: headers, body: body);

      if (response.statusCode != 204) {
        throw Exception('Report failed.');
      }

      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
