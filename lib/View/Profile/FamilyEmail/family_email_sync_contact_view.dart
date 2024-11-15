import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Profile/FamilyEmail/family_email_sync_contact_controller.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_request.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_info_tile.dart';

class FamilyEmailSyncContactView extends StatefulWidget {
  const FamilyEmailSyncContactView({
    super.key,
    this.registeredEmailList,
  });
  final List<FamilyEmail>? registeredEmailList;

  @override
  State<FamilyEmailSyncContactView> createState() =>
      _FamilyEmailSyncContactViewState();
}

class _FamilyEmailSyncContactViewState
    extends State<FamilyEmailSyncContactView> {
  late FamilyEmailSyncContactController controller;
  @override
  void initState() {
    super.initState();
    controller = FamilyEmailSyncContactController(widget.registeredEmailList);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return CustomScaffold(
      appBar: CustomAppBar(
        title: '家族メール設定',
      ),
      isScrollable: true,
      body: SizedBox(
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: deviceWidth * 0.9,
              height: 48,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: CustomText(text: '未登録'),
              ),
            ),
            FutureBuilder<List<FamilyEmailRequest>?>(
              future: controller.getFamilyEmailRequest(),
              builder:
                  (context, AsyncSnapshot<List<FamilyEmailRequest>?> snapshot) {
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
                  // todo: エラー時の処理
                  return Container();
                }
                List<FamilyEmailRequest> familyEmailRequestList =
                    snapshot.data!;
                if (familyEmailRequestList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(
                      top: 100,
                    ),
                    child: CustomText(text: 'メールアドレスが登録されていません'),
                  );
                }
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: familyEmailRequestList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: UserInfoTile(
                          onTap: () async {
                            int res = await controller
                                .postFamilyEmail(familyEmailRequestList[index]);
                            if (res != 200) {
                              return;
                            }
                            await controller.updateFamilyEmail();
                          },
                          imageUrl: familyEmailRequestList[index].iconImageUrl,
                          userName:
                              '${familyEmailRequestList[index].lastName} ${familyEmailRequestList[index].firstName}',
                          description: familyEmailRequestList[index].email,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
