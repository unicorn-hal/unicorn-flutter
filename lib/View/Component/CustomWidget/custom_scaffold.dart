import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final bool isScrollable;
  final bool isAppbar;
  final FocusNode? focusNode;
  final ScrollController? scrollController;

  const CustomScaffold({
    super.key,
    required this.body,
    this.title,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
    this.actions,
    this.isScrollable = false,
    this.isAppbar = true,
    this.focusNode,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode?.requestFocus,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.images.background.provider(),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Scaffold(
            // backgroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            appBar: isAppbar
                ? appBar ??
                    CustomAppBar(
                      title: title,
                      actions: actions,
                      backgroundColor: ColorName.mainColor,
                    )
                : null,
            body: isScrollable
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: body,
                  )
                : body,
            drawer: drawer,
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
          ),
        ),
      ),
    );
  }
}
