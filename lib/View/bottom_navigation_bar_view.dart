import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/bottom_navigation_bar_controller.dart';

class BottomNavigationBarView extends StatefulWidget {
  const BottomNavigationBarView({super.key});

  @override
  State<BottomNavigationBarView> createState() =>
      _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    BottomNavigationBarController().appLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarController controller = BottomNavigationBarController();
    return Scaffold(
      body: controller.navigationShell,
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          NavigationBar(
            selectedIndex: controller.navigationShell.currentIndex,
            // todo: カラーアセット確定後に修正する
            // indicatorColor: Colors.green.withOpacity(0.2),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'ホーム'),
              NavigationDestination(
                  icon: Icon(Icons.health_and_safety_outlined), label: '検診'),
              NavigationDestination(icon: Icon(Icons.chat), label: 'チャット'),
              NavigationDestination(icon: Icon(Icons.person), label: 'プロフィール'),
            ],
            onDestinationSelected: (index) {
              controller.goBranch(index);
            },
          ),
        ],
      ),
    );
  }
}
