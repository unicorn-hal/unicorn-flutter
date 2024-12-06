import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unicorn_flutter/Route/navigation_shell.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

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

  /// アイテムの返却
  List<NavigationDestination> destination() {
    List<NavigationDestination> destinations = [
      NavigationDestination(
        icon: Assets.images.bottomNavBar.home.image(
          scale: 20.0,
        ),
        selectedIcon: Assets.images.bottomNavBar.home.image(
          scale: 18.0,
          color: ColorName.mainColor,
        ),
        label: 'ホーム',
      ),
      NavigationDestination(
        icon: Assets.images.bottomNavBar.healthCheckup.image(
          scale: 20.0,
        ),
        selectedIcon: Assets.images.bottomNavBar.healthCheckup.image(
          scale: 18.0,
          color: ColorName.mainColor,
        ),
        label: '検診',
      ),
      NavigationDestination(
        icon: Assets.images.bottomNavBar.chat.image(
          scale: 20.0,
        ),
        selectedIcon: Assets.images.bottomNavBar.chat.image(
          scale: 18.0,
          color: ColorName.mainColor,
        ),
        label: 'チャット',
      ),
      NavigationDestination(
        icon: Assets.images.bottomNavBar.profile.image(
          scale: 20.0,
        ),
        selectedIcon: Assets.images.bottomNavBar.profile.image(
          scale: 18.0,
          color: ColorName.mainColor,
        ),
        label: 'プロフィール',
      ),
    ];

    return destinations;
  }
}
