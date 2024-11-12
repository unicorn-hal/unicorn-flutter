import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';

class LicenseView extends StatelessWidget {
  const LicenseView({
    super.key,
    required this.appVersion,
  });
  final String appVersion;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbar: false,
      body: LicensePage(
        applicationName: 'Unicorn',
        applicationVersion: appVersion,
        applicationIcon: const Placeholder(),
        // todo: アイコンできたらぶちこみ
        applicationLegalese: 'All rights reserved',
      ),
    );
  }
}
