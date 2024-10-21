import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/profile_detail_cell.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';

class ProfileTopView extends StatelessWidget {
  const ProfileTopView({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    String lastName = 'のりた';
    String firstName = 'しおき';
    return CustomScaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  child: UserImageCircle(
                    imageSize: 100,
                  ),
                ),
                Row(
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
              ],
            ),
            Container(
              width: deviceWidth,
              height: deviceHeight * 0.55,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 223, 223, 223),
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
                  itemCount: 11,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ProfileDetailCell(
                        icon: Icon(Icons.add_circle_outline),
                        title: '項目${index}',
                        onTap: () {
                          print('👑ｵｻﾚﾀﾖｯ${index}');
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
