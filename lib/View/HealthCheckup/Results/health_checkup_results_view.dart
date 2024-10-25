import 'package:flutter/material.dart';

import '../../Component/CustomWidget/custom_scaffold.dart';

class HealthCheckupResultsView extends StatelessWidget {
  const HealthCheckupResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      body: Center(
        child: Column(
          children: [
            Container(width: size.width * 0.8, height: 500),
          ],
        ),
      ),
    );
  }
}
