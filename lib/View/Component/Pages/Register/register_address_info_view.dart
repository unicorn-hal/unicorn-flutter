import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unicorn_flutter/Controller/Component/Pages/Register/register_address_info_controller.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dropdown.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/google_map_viewer.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class RegisterAddressInfoView extends StatefulWidget {
  const RegisterAddressInfoView({
    super.key,
    this.userRequest,
    required this.from,
  });
  final UserRequest? userRequest;
  final String from;

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
    controller = RegisterAddressInfoController(
      context: context,
      from: widget.from,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CustomScaffold(
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
                      onTap: () async {
                        await controller.setAddressFromLocation();
                        setState(() {});
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
                          controller: controller.postalCodeTextController,
                          onTapOutside: (p0) async {
                            await controller.updateMapPinPosition();
                            setState(() {});
                          },
                        ),
                        GestureDetector(
                          onTap: () async {
                            await controller.setAddressFromPostalCode();
                            setState(() {});
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
                      dropdownItems: controller.countryList(),
                      selectIndex: controller.selectedPrefectureIndex,
                      height: 44,
                      onChanged: (int? index) async {
                        controller.selectedPrefectureIndex = index ?? 0;
                        await controller.updateMapPinPosition();
                        setState(() {});
                      },
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
                      controller: controller.municipalitiesTextController,
                      maxLines: 1,
                      maxLength: 25,
                      onTapOutside: (p0) async {
                        await controller.updateMapPinPosition();
                        setState(() {});
                      },
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
                      controller: controller.addressDetailTextController,
                      maxLines: 1,
                      maxLength: 25,
                      onTapOutside: (p0) async {
                        await controller.updateMapPinPosition();
                        setState(() {});
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: deviceWidth,
                        height: 170,
                        color: Colors.grey,
                        child: ValueListenableBuilder(
                            valueListenable: controller.mapPinPosition,
                            builder: (context, value, child) {
                              return GoogleMapViewer(
                                point: value,
                              );
                            }),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await controller.submit(widget.userRequest!);
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 30),
                          child: Container(
                              width: deviceWidth * 0.5,
                              height: 60,
                              color: ColorName.profileInputButtonColor,
                              child: Center(
                                child: CustomText(
                                  text: widget.from == Routes.profile
                                      ? '保存する'
                                      : '次に進む',
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
        ),
        ValueListenableBuilder(
            valueListenable: controller.protector,
            builder: (context, value, child) {
              if (value == false) {
                return Container();
              }
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.amber,
                          size: 54,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            })
      ],
    );
  }
}
