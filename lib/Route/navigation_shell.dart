import 'package:go_router/go_router.dart';

class NavigationShell {
  static final NavigationShell _instance = NavigationShell._internal();
  factory NavigationShell() => _instance;
  NavigationShell._internal();

  StatefulNavigationShell? _navigationShell;

  void set(StatefulNavigationShell navigationShell) {
    _navigationShell = navigationShell;
  }

  StatefulNavigationShell get() {
    return _navigationShell!;
  }
}
