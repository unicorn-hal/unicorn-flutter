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
  bool _value = false;
  bool appBarAction = true;
  // todo: controller出来たら削除
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return CustomScaffold(
      isScrollable: true,
      appBar: CustomAppBar(
        backgroundColor: ColorName.mainColor,
        actions: appBarAction
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // todo: controller出来たら削除処理追加
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.black,
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
                child: CustomText(text: '常備薬のリマインダー設定'),
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
                ),
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.9,
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _value,
                        onChanged: (value) => setState(() => _value = value!),
                      ),
                      const CustomText(text: 'リマインドする')
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        CustomDrumRoll(
                          showTime: false,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomDrumRoll(
                          showTime: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    child: CustomButton(
                      text: '決定',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      isFilledColor: true,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
