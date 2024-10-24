import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_drum_roll.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class RegularMedicineSettingView extends StatefulWidget {
  const RegularMedicineSettingView({super.key});

  @override
  State<RegularMedicineSettingView> createState() =>
      _RegularMedicineSettingViewState();
}

class _RegularMedicineSettingViewState
    extends State<RegularMedicineSettingView> {
  TextEditingController controller = TextEditingController();
  bool registration = true;
  bool reminder = false;
  // todo: controller出来たら削除
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return CustomScaffold(
      isScrollable: true,
      appBar: CustomAppBar(
        title: '常備薬の登録',
        foregroundColor: Colors.white,
        backgroundColor: ColorName.mainColor,
        actions: registration
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // todo: controller出来たら削除処理追加
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                ),
              ]
            : null,
      ),
      body: SizedBox(
        width: deviceWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: deviceWidth * 0.9,
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 5,
                ),
                child: CustomText(text: 'おくすりの名称'),
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.9,
              height: 70,
              child: CustomTextfield(
                hintText: '20文字以内で入力してください',
                controller: controller,
                height: 50,
                maxLines: 1,
              ),
            ),
            Container(
              width: deviceWidth * 0.9,
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 5,
                ),
                child: CustomText(text: 'おくすりの錠数'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
              ),
              child: SizedBox(
                width: deviceWidth * 0.9,
                height: 70,
                child: CustomTextfield(
                  hintText: 'おくすりの名称',
                  controller: controller,
                  height: 50,
                  maxLines: 1,
                  number: true,
                ),
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 5,
                    ),
                    child: CustomText(text: 'リマインダーを設定'),
                  ),
                  reminder
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 20,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  reminder = !reminder;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.remove_circle_outlined,
                                    color: Colors.red),
                              ),
                              CustomDrumRoll(
                                showTime: false,
                                reservation: DateTime.now(),
                                // todo: リマインダー設定がすでにある場合reservationに入れる
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomDrumRoll(
                                showTime: true,
                                reservation: DateTime.now(),
                                // todo: リマインダー設定がすでにある場合reservationに入れる
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 20,
                          ),
                          child: IconButton(
                            onPressed: () {
                              reminder = !reminder;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    child: CustomButton(
                      text: '保存',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      isFilledColor: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
