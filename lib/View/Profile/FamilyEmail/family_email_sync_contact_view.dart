import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Profile/FamilyEmail/family_email_sync_contact_controller.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_post_request.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/header_title.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_info_tile.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class FamilyEmailSyncContactView extends StatefulWidget {
  const FamilyEmailSyncContactView({
    super.key,
    this.familyEmailList,
  });
  final List<FamilyEmail>? familyEmailList;

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
    controller = FamilyEmailSyncContactController(widget.familyEmailList);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return CustomScaffold(
      appBar: CustomAppBar(
        title: '連絡先から追加',
        foregroundColor: Colors.white,
        backgroundColor: ColorName.mainColor,
      ),
      isScrollable: true,
      body: SizedBox(
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: HeaderTitle(
                title: '未登録の連絡先',
              ),
            ),
            FutureBuilder<List<FamilyEmailPostRequest>?>(
              future: controller.getFamilyEmailRequest(),
              builder: (context,
                  AsyncSnapshot<List<FamilyEmailPostRequest>?> snapshot) {
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
                List<FamilyEmailPostRequest> familyEmailRequestList =
                    snapshot.data!;
                if (familyEmailRequestList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(
                      top: 100,
                    ),
                    child: CustomText(
                        text: Strings.FAMILY_EMAIL_NOT_REGISTERED_TEXT),
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
                      child: UserInfoTile(
                        onTap: () async {
                          int res = await controller
                              .postFamilyEmail(familyEmailRequestList[index]);
                          if (res != 200) {
                            return;
                          }
                          await controller.updateFamilyEmail();
                          setState(() {});
                        },
                        localImage: familyEmailRequestList[index].avatar !=
                                    null &&
                                familyEmailRequestList[index].avatar!.isNotEmpty
                            ? controller.uint8ListToImage(
                                familyEmailRequestList[index].avatar!)
                            : null,
                        userName:
                            '${familyEmailRequestList[index].lastName} ${familyEmailRequestList[index].firstName}',
                        description: familyEmailRequestList[index].email == ''
                            ? 'メールアドレス未設定'
                            : familyEmailRequestList[index].email,
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
