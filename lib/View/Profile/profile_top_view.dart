import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                UserImageCircle(
                  imageSize: 120,
                  imagePath:
                      'https://storage.googleapis.com/lab-mode-cms-production/images/message_contents_01__2/original_message_contents_01__2.jpg',
                  onTap: () {
                    print('のりたし!!!');
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: lastName,
                      fontSize: 32,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      text: firstName,
                      fontSize: 32,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: deviceWidth,
              height: deviceHeight * 0.5,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 223, 223, 223),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: (1 / 1),
                  ),
                  itemCount: 9,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(18),
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
            //Text('Profile Top View'),
          ],
        ),
      ),
    );
  }
}
