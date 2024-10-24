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
  bool _value1 = false;
  bool _value2 = false;

  // todo: controller出来たら消す
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    String title1 = 'おくすり通知';
    String title2 = '定時検診';
    String title3 = '新着病院お知らせ';
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
            CommonItemTile(
              title: title1,
              // todo: controller出来たら変更
              action: CupertinoSwitch(
                value: _value,
                onChanged: (value) => setState(() => _value = value),
              ),
              onTap: () {
                _value = !_value;
                setState(() {});
              },
              // todo: viewが全部出来たタイミングでvoidCallbackに変える
            ),
            CommonItemTile(
              title: title2,
              // todo: controller出来たら変更
              action: CupertinoSwitch(
                value: _value1,
                onChanged: (value) => setState(() => _value1 = value),
              ),
              onTap: () {
                _value1 = !_value1;
                setState(() {});
              },
              // todo: viewが全部出来たタイミングでvoidCallbackに変える
            ),
            CommonItemTile(
              title: title3,
              // todo: controller出来たら変更
              action: CupertinoSwitch(
                value: _value2,
                onChanged: (value) => setState(() => _value2 = value),
              ),
              onTap: () {
                _value2 = !_value2;
                setState(() {});
              },
              // todo: viewが全部出来たタイミングでvoidCallbackに変える
            ),
          ],
        ),
      ),
    );
  }
}
