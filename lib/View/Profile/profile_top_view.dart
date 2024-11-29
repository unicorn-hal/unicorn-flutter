import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicorn_flutter/Controller/Profile/profile_top_controller.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/profile_detail_cell.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class ProfileTopView extends StatelessWidget {
  const ProfileTopView({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileTopController controller = ProfileTopController(context);
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return CustomScaffold(
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer(builder: (context, ref, _) {
            UserData userData = ref.watch(userDataProvider);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  child: UserImageCircle(
                    imageUrl: userData.user!.iconImageUrl,
                    imageSize: 120,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: userData.user!.lastName,
                        fontSize: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomText(
                        text: userData.user!.firstName,
                        fontSize: 30,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          Container(
            width: deviceWidth,
            height: deviceHeight * 0.7,
            decoration: const BoxDecoration(
              color: ColorName.profileBackgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 40,
                right: 40,
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: (1 / 1),
                ),
                itemCount: controller.cellData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ProfileDetailCell(
                      icon: Icon(
                        controller.cellData[index].icon,
                        color: ColorName.mainColor,
                      ),
                      title: controller.cellData[index].title,
                      onTap: () => controller.cellData[index].onTap.call(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
