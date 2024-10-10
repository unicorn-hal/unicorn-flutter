import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';

class ProfileTopView extends StatelessWidget {
  const ProfileTopView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile Top View'),
          ],
        ),
      ),
    );
  }
}
