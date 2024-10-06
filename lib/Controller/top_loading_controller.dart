// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class TopLoadingController {
  final BuildContext context;

  TopLoadingController(this.context);

  void firstLoad() async {
    // todo: 初回起動時の処理を記述

    Log.echo('TopLoadingController: firstLoad', symbol: '🔍');
    await Future.delayed(const Duration(seconds: 1));
    const HomeRoute().go(context);
  }
}
