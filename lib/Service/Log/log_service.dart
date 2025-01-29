import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Log {
  static final Log instance = Log._internal();
  factory Log() => instance;
  Log._internal();

  static void echo(String message, {String symbol = '👑'}) {
    if (kDebugMode) {
      print('$symbol >> $message');
    }
  }

  static void toast(String message, {String symbol = '🍞'}) {
    if (kDebugMode) {
      Fluttertoast.showToast(
        msg: '$symbol >> $message',
      );
    }
  }
}
