import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Profile/FamilyEmail/family_email_controller.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_info_tile.dart';

class FamilyEmailView extends StatefulWidget {
  const FamilyEmailView({
    super.key,
    required this.from,
  });
  final String from;

  @override
  State<FamilyEmailView> createState() => _FamilyEmailViewState();
}

class _FamilyEmailViewState extends State<FamilyEmailView> {
  late FamilyEmailController controller;
  @override
  void initState() {
    super.initState();
    controller = FamilyEmailController(from: widget.from);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomScaffold(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(text: controller.title),
                      Visibility(
                        visible: !controller.isSyncContact,
                        child: IconButton(
                          onPressed: () {
                            const ProfileFamilyEmailRegisterRoute()
                                .push(context)
                                .then((value) => setState(() {}));
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<List<FamilyEmail>?>(
                    future: controller.getFamilyEmail(),
                    builder: (
                      context,
                      AsyncSnapshot<List<FamilyEmail>?> snapshot,
                    ) {
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
                      List<FamilyEmail>? familyEmailList = snapshot.data;
                      if (familyEmailList!.isEmpty) {
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
                        itemCount: familyEmailList.length,
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
                                onTap: () {
                                  ProfileFamilyEmailRegisterRoute()
                                      .push(context)
                                      .then((value) => setState(() {}));
                                },
                                imageUrl: familyEmailList[index].iconImageUrl,
                                userName:
                                    '${familyEmailList[index].lastName} ${familyEmailList[index].firstName}',
                                description: familyEmailList[index].email,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        ),
        !controller.isSyncContact
            ? Container(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                width: 300,
                height: 60,
                child: CustomButton(
                  isFilledColor: true,
                  text: '連絡先から追加',
                  onTap: () {
                    const ProfileFamilyEmailSyncContactRoute(
                            from: Routes.profileFamilyEmail)
                        .push(context)
                        .then((value) => setState(() {}));
                    // todo: controller出来たら引数もらってくる
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}
