import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? body;
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final bool isScrollable;
  final bool isAppbar;

  const CustomScaffold({
    super.key,
    this.body,
    this.title,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
    this.actions,
    this.isScrollable = false,
    this.isAppbar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isAppbar
          ? appBar ??
              // todo: CustomAppBar確定後に修正する
              AppBar(
                title: Text(title ?? ''),
                actions: actions,
                backgroundColor: Colors.red,
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
