import 'package:flutter/material.dart';

class ChatTopView extends StatelessWidget {
  const ChatTopView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chat Top View'),
          ],
        ),
      ),
    );
  }
}
