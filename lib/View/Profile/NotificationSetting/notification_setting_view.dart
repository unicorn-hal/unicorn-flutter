import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Profile/NotificationSetting/notification_setting_controller.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_notification.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/header_title.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class NotificationSettingView extends StatefulWidget {
  const NotificationSettingView({
    super.key,
    required this.userNotification,
  });
  final UserNotification userNotification;

  @override
  State<NotificationSettingView> createState() =>
      _NotificationSettingViewState();
}

class _NotificationSettingViewState extends State<NotificationSettingView> {
  late NotificationSettingController controller;
  @override
  void initState() {
    super.initState();
    controller = NotificationSettingController(widget.userNotification);
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
        if (widget.userNotification == controller.userNotification) {
          Navigator.of(context).pop(true);
          return;
        }
        await controller.putUserNotification();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true);
      },
      child: CustomScaffold(
        appBar: CustomAppBar(
          title: '通知設定',
          foregroundColor: Colors.white,
          backgroundColor: ColorName.mainColor,
        ),
        body: SizedBox(
          width: deviceWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              CommonItemTile(
                title: 'おくすり通知',
                action: CupertinoSwitch(
                  value: controller.userNotification!.isMedicineReminder,
                  onChanged: (value) => setState(
                      () => controller.setMedicineNotificationValue(value)),
                ),
                onTap: () {
                  controller.setMedicineNotificationValue(
                      !controller.userNotification!.isMedicineReminder);
                  setState(() {});
                },
              ),
              CommonItemTile(
                title: '定時検診',
                action: CupertinoSwitch(
                  value: controller.userNotification!.isRegularHealthCheckup,
                  onChanged: (value) =>
                      setState(() => controller.setHealthCheckupValue(value)),
                ),
                onTap: () {
                  controller.setHealthCheckupValue(
                      !controller.userNotification!.isRegularHealthCheckup);
                  setState(() {});
                },
              ),
              CommonItemTile(
                title: '新着病院お知らせ',
                action: CupertinoSwitch(
                  value: controller.userNotification!.isHospitalNews,
                  onChanged: (value) => setState(
                      () => controller.setHospitalNotificationValue(value)),
                ),
                onTap: () {
                  controller.setHospitalNotificationValue(
                      !controller.userNotification!.isHospitalNews);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
