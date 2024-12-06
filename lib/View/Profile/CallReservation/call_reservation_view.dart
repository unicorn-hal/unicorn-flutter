import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/call_reservation_tile.dart';

class CallReservationView extends StatefulWidget {
  const CallReservationView({super.key});

  @override
  State<CallReservationView> createState() => _CallReservationViewState();
}

class _CallReservationViewState extends State<CallReservationView> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return CustomScaffold(
      isScrollable: true,
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
