import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
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
  final bool resizeToAvoidBottomInset;

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
    this.resizeToAvoidBottomInset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              child: body,
            )
          : body,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
