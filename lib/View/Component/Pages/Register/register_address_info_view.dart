import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Component/Pages/Register/register_address_info_controller.dart';
import 'package:unicorn_flutter/Model/Entity/User/physical_info.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dropdown.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class RegisterAddressInfoView extends StatefulWidget {
  const RegisterAddressInfoView({super.key, this.physicalInfo});
  final PhysicalInfo? physicalInfo;

  @override
  State<RegisterAddressInfoView> createState() =>
      _RegisterAddressInfoViewState();
}

class _RegisterAddressInfoViewState extends State<RegisterAddressInfoView> {
  late RegisterAddressInfoController controller;

  final FocusNode focusnode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = RegisterAddressInfoController();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<int>> dropdownItems =
        controller.entryItemStrings
            .map((e) => DropdownMenuItem(
                  value: controller.entryItemStrings.indexOf(e),
                  child: CustomText(
                    text: e,
                  ),
                ))
            .toList();
    final deviceWidth = MediaQuery.of(context).size.width;
    return CustomScaffold(
      focusNode: focusnode,
      isAppbar: false,
      isScrollable: true,
      body: SafeArea(
        child: SizedBox(
          width: deviceWidth,
          child: FractionallySizedBox(
            widthFactor: 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: ColorName.textGray),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            CustomText(
                              text: 'Address',
                              color: ColorName.profileInputBackgroundColor,
                              fontSize: 24,
                            ),
                            CustomText(
                              text: '住所情報を入力してください',
                              color: ColorName.textBlack,
                              fontSize: 24,
                            ),
                          ],
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // todo: controllerでき次第ここに追記します。
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                          width: deviceWidth * 0.8,
                          height: 60,
                          decoration: BoxDecoration(
                              color: ColorName.profileInputButtonColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              CustomText(
                                text: '現在地から自動入力する',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: CustomText(
                    text: '郵便番号（ハイフンなし）',
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextfield(
                      hintText: '数字7桁',
                      width: deviceWidth * 0.5,
                      height: 44,
                      maxLines: 1,
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      controller: controller.addressNumber,
                    ),
                    GestureDetector(
                      onTap: () {
                        // todo: controllerでき次第ここに追記します。
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: deviceWidth * 0.3,
                            height: 48,
                            decoration: BoxDecoration(
                                color: ColorName.profileInputButtonColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.search_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                CustomText(
                                  text: '検索',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: CustomText(
                    text: '都道府県',
                    fontSize: 20,
                  ),
                ),
                CustomDropdown(
                  dropdownItems: dropdownItems,
                  height: 44,
                  onChanged: (int? index) {},
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: CustomText(
                    text: '市区町村',
                    fontSize: 20,
                  ),
                ),
                CustomTextfield(
                  hintText: '静岡市葵区追手町５－１',
                  width: deviceWidth * 0.85,
                  height: 44,
                  controller: controller.address,
                  maxLines: 1,
                  maxLength: 25,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: CustomText(
                    text: '部屋番号など',
                    fontSize: 20,
                  ),
                ),
                CustomTextfield(
                  hintText: 'ユニコーンビル１０３号',
                  width: deviceWidth * 0.85,
                  height: 44,
                  controller: controller.addressDetail,
                  maxLines: 1,
                  maxLength: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: deviceWidth,
                    height: 170,
                    color: Colors.grey,
                    child: Text('ここに地図入ります'),
                    // todo: 地図でき次第ここに入れます。（とりあえずContainerだけ設けました）
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  // todo: 次のViewができ次第ルーティングします。
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Container(
                          width: deviceWidth * 0.5,
                          height: 60,
                          color: ColorName.profileInputButtonColor,
                          child: const Center(
                            child: CustomText(
                              text: '次に進む',
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
