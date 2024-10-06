import 'package:flutter/material.dart';

class HealthCheckupTopView extends StatelessWidget {
  const HealthCheckupTopView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Health Checkup Top View'),
          ],
        ),
      ),
    );
  }
}
