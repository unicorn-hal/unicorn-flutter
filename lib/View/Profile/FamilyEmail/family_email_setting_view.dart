import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_info_tile.dart';

class FamilyEmailSettingView extends StatelessWidget {
  const FamilyEmailSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    String lastName = 'のりた';
    String firstName = 'しおき';
    String email = 'sample@sample.com';
    bool isAddButton = true;
    String appBarTitle = '家族メール設定';
    String title = '登録済み';
    bool isImportContact = true;
    // todo: controller出来たら変更

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomScaffold(
          appBar: CustomAppBar(
            title: appBarTitle,
          ),
          isScrollable: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(text: title),
                    Visibility(
                      visible: isAddButton,
                      child: IconButton(
                        onPressed: () {},
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
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 20,
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
                        onTap: () {},
                        userName: '$lastName $firstName',
                        description: email,
                        // todo: controller出来たら変更
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
        isImportContact
            ? Container(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                width: 300,
                height: 60,
                child: CustomButton(
                  isFilledColor: true,
                  text: '連絡先から追加',
                  onTap: () {},
                ),
              )
            : Container(),
      ],
    );
  }
}
