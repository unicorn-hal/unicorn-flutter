import 'package:flutter/cupertino.dart';
import 'package:unicorn_flutter/Controller/Profile/NotificationSetting/notification_setting_controller.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_notification.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';

class NotificationSettingView extends StatefulWidget {
  const NotificationSettingView({
    super.key,
    this.userNotification,
  });
  final UserNotification? userNotification;

  @override
  State<NotificationSettingView> createState() =>
      _NotificationSettingViewState();
}

class _NotificationSettingViewState extends State<NotificationSettingView> {
  late NotificationSettingController controller;
  @override
  void initState() {
    super.initState();
    controller = NotificationSettingController();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (controller.userNotification ==
            controller.formatedUserNotification.value) {
          Navigator.of(context).pop(true);
          return;
        }
        controller.userNotification == null
            ? await controller.postUserNotification()
            : await controller.putUserNotification();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true);
      },
      child: CustomScaffold(
        body: SizedBox(
          width: deviceWidth,
          child: ValueListenableBuilder(
              valueListenable: controller.formatedUserNotification,
              builder: (
                context,
                value,
                child,
              ) {
                return Column(
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
                      title: 'おくすり通知',
                      action: CupertinoSwitch(
                        value: value.isMedicineReminder,
                        onChanged: (value) => setState(() =>
                            controller.setMedicineNotificationValue(value)),
                      ),
                      onTap: () {
                        controller.setMedicineNotificationValue(
                            !value.isMedicineReminder);
                        setState(() {});
                      },
                    ),
                    CommonItemTile(
                      title: '定時検診',
                      action: CupertinoSwitch(
                        value: value.isRegularHealthCheckup,
                        onChanged: (value) => setState(
                            () => controller.setHealthCheckupValue(value)),
                      ),
                      onTap: () {
                        controller.setHealthCheckupValue(
                            !value.isRegularHealthCheckup);
                        setState(() {});
                      },
                    ),
                    CommonItemTile(
                      title: '新着病院お知らせ',
                      action: CupertinoSwitch(
                        value: value.isHospitalNews,
                        onChanged: (value) => setState(() =>
                            controller.setHospitalNotificationValue(value)),
                      ),
                      onTap: () {
                        controller.setHospitalNotificationValue(
                            !value.isHospitalNews);
                        setState(() {});
                      },
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
