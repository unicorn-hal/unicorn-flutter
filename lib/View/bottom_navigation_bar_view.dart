import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unicorn_flutter/Controller/bottom_navigation_bar_controller.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class ProtectorNotifier extends ChangeNotifier {
  static final ProtectorNotifier _instance = ProtectorNotifier._internal();
  factory ProtectorNotifier() => _instance;
  ProtectorNotifier._internal();

  bool _useProtector = false;
  bool get useProtector => _useProtector;

  void enableProtector() {
    _useProtector = true;
    notifyListeners();
  }

  void disableProtector() {
    _useProtector = false;
    notifyListeners();
  }
}

final protectorProvider =
    ChangeNotifierProvider<ProtectorNotifier>((ref) => ProtectorNotifier());

class BottomNavigationBarView extends StatefulWidget {
  const BottomNavigationBarView({super.key});

  @override
  State<BottomNavigationBarView> createState() =>
      _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView>
    with WidgetsBindingObserver {
  late BottomNavigationBarController controller;

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
    controller = BottomNavigationBarController();
    final deviceHeight = MediaQuery.of(context).size.height;

    final Widget protector = Container(
      height: deviceHeight,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Colors.amber,
          size: 54,
        ),
      ),
    );

    return Consumer(builder: (context, ref, _) {
      final protectorNotifier = ref.watch(protectorProvider);
      return Stack(
        children: [
          CustomScaffold(
            isAppbar: false,
            body: controller.navigationShell,
            bottomNavigationBar: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                NavigationBar(
                  selectedIndex: controller.navigationShell.currentIndex,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 4.0,
                  shadowColor: Colors.amber,
                  indicatorColor: ColorName.mainColor.withOpacity(0.2),
                  destinations: controller.destination(),
                  onDestinationSelected: (index) {
                    controller.goBranch(index);
                  },
                ),
              ],
            ),
          ),
          if (protectorNotifier.useProtector) protector,
        ],
      );
    });
  }
}
