import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Model/Data/Department/department_data.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_modal.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/call_reservation_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class CallReservationView extends StatefulWidget {
  const CallReservationView({super.key});

  @override
  State<CallReservationView> createState() => _CallReservationViewState();
}

class _CallReservationViewState extends State<CallReservationView> {
  @override
  Widget build(BuildContext context) {
    bool test = true;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return CustomScaffold(
      isScrollable: true,
      appBar: CustomAppBar(
        backgroundColor: ColorName.mainColor,
        actions: [
          CustomButton(
            text: '全ての予約',
            onTap: () {
              showModalBottomSheet(
                useRootNavigator: true,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return CustomModal(
                    title: '',
                    leftButtonOnTap: () {},
                    topMargin: 100,
                    content: StatefulBuilder(
                        builder: (context, StateSetter setState) {
                      return SizedBox(
                        width: deviceWidth * 0.9,
                        height: deviceHeight * 0.6,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: DepartmentData().data.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return CommonItemTile(
                                title: '全ての予約',
                                action: test
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.blue,
                                      )
                                    : null,
                                onTap: () {
                                  setState(() {});
                                },
                              );
                            } else {
                              return CommonItemTile(
                                title: DepartmentData()
                                    .data[index - 1]
                                    .departmentName,
                                action: test
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.blue,
                                      )
                                    : null,
                                onTap: () {
                                  setState(() {});
                                },
                              );
                            }
                          },
                        ),
                      );
                    }),
                  );
                },
              );
            },
            isFilledColor: true,
          )
        ],
      ),
      body: SizedBox(
        width: deviceWidth,
        child: Column(
          children: [
            Container(
              width: deviceWidth * 0.9,
              padding: const EdgeInsets.only(
                left: 5,
                top: 20,
                bottom: 10,
              ),
              child: const CustomText(text: '通話予約'),
            ),
            SizedBox(
              width: deviceWidth * 0.9,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CallReservationTile(
                      doctorName: 'のりたしおき',
                      callDate: '2024年12月10日',
                      callTime: '12:00 ~ 12:30',
                      doctorIconUrl: 'https://placehold.jp/150x150.png',
                      chatButtonOnTap: () {},
                      deleteButtonOnTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (_) {
                            return CustomDialog(
                              title: Strings.DIALOG_TITLE_CAVEAT,
                              bodyText: Strings.DIALOG_BODY_TEXT_DELETE,
                              rightButtonOnTap: () {},
                            );
                          },
                        );
                      },
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
