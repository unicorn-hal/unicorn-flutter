import 'package:flutter/cupertino.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';

class NotificationSettingView extends StatefulWidget {
  const NotificationSettingView({super.key});

  @override
  State<NotificationSettingView> createState() =>
      _NotificationSettingViewState();
}

class _NotificationSettingViewState extends State<NotificationSettingView> {
  bool _value = false;
  // todo: controller出来たら消す
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    List<String> settings = [
      'おくすり通知',
      '定時検診',
      '新着病院お知らせ',
    ];
    // todo: controller出来たら消す
    return CustomScaffold(
      body: SizedBox(
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 5,
                top: 20,
                bottom: 20,
              ),
              width: deviceWidth * 0.9,
              child: const CustomText(text: '通知設定'),
            ),
            SizedBox(
              width: deviceWidth * 0.9,
              child: ListView.builder(
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return CommonItemTile(
                    title: settings[index],
                    // todo: controller出来たら変更
                    action: CupertinoSwitch(
                      value: _value,
                      onChanged: (value) => setState(() => _value = value),
                      // todo: Statelessでやるやり方あったかも
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
