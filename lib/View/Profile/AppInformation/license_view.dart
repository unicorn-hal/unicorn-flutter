import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

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
        applicationIcon: SizedBox(
          width: 100,
          height: 100,
          child: Assets.images.launcher.unicornAppIcon.image(),
        ),
        applicationLegalese: 'All rights reserved',
      ),
    );
  }
}
