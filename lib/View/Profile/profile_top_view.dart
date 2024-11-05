import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Profile/profile_top_controller.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
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
    String lastName = 'のりた';
    String firstName = 'しおき';
    // todo: controller出来たら消す
    return CustomScaffold(
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: UserImageCircle(
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
                      text: lastName,
                      fontSize: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      text: firstName,
                      fontSize: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
