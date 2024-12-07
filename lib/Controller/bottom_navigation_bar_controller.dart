import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unicorn_flutter/Route/navigation_shell.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class BottomNavigationBarController {
  late StatefulNavigationShell navigationShell;

  BottomNavigationBarController() {
    navigationShell = NavigationShell().get();
  }

  /// アプリのライフサイクルをコントロールする
  void appLifecycleState(AppLifecycleState state) {
    Log.echo('AppLifecycleState: $state', symbol: '🔍');
  }

  /// 指定したインデックスのブランチに移動する
  void goBranch(int index) {
    if (index == navigationShell.currentIndex) {
      navigationShell.goBranch(index, initialLocation: true);
      return;
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
