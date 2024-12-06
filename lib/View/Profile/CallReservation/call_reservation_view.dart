import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Profile/CallReservation/call_reservation_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_reservation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/call_reservation_tile.dart';

class CallReservationView extends StatefulWidget {
  const CallReservationView({super.key});

  @override
  State<CallReservationView> createState() => _CallReservationViewState();
}

class _CallReservationViewState extends State<CallReservationView> {
  late CallReservationController controller;
  @override
  void initState() {
    super.initState();
    controller = CallReservationController();
  }

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
            FutureBuilder<List<CallReservation>?>(
              future: controller.getCallReservation(),
              builder:
                  (context, AsyncSnapshot<List<CallReservation>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CustomLoadingAnimation(
                      text: Strings.LOADING_TEXT,
                      iconColor: Colors.grey,
                      textColor: Colors.grey,
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return Container();
                }
                List<CallReservation> callReservationList = snapshot.data!;
                if (callReservationList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(
                      top: 100,
                    ),
                    child: CustomText(
                        text: Strings.CALL_RESERVATION_NOT_REGISTERED_TEXT),
                  );
                }
                return SizedBox(
                  width: deviceWidth * 0.9,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: callReservationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CallReservationTile(
                          doctorName:
                              '${callReservationList[index].doctor.lastName}${callReservationList[index].doctor.firstName}',
                          callDate: DateFormat('yyyy年MM月dd日')
                              .format(callReservationList[index].callStartTime),
                          callTime:
                              '${DateFormat('HH:mm').format(callReservationList[index].callStartTime)} ~ ${DateFormat('HH:mm').format(callReservationList[index].callEndTime)}',
                          doctorIconUrl:
                              callReservationList[index].doctor.doctorIconUrl,
                          chatButtonOnTap: () {},
                          deleteButtonOnTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (_) {
                                return CustomDialog(
                                  title: Strings.DIALOG_TITLE_CAVEAT,
                                  bodyText: Strings.DIALOG_BODY_TEXT_DELETE,
                                  rightButtonOnTap: () async {
                                    int res =
                                        await controller.deleteCallReservation(
                                            callReservationList[index]
                                                .callReservationId);
                                    if (res == 204) {
                                      setState(() {});
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
