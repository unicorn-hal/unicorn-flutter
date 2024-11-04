import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/top_loading_controller.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class TopLoadingView extends StatelessWidget {
  const TopLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      TopLoadingController(context);
    } catch (e) {
      Log.echo('TopLoading Error: $e', symbol: '❌');
    }
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Now Loading...',
              style: TextStyle(
                fontSize: deviceHeight * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
