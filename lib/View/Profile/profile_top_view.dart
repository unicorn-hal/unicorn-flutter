import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class ProfileTopView extends StatelessWidget {
  const ProfileTopView({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return CustomScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    print('のりたし!!!');
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.5),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                            'https://storage.googleapis.com/lab-mode-cms-production/images/message_contents_01__2/original_message_contents_01__2.jpg'),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'のりた',
                      fontSize: 32,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      text: 'しおき',
                      fontSize: 32,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: deviceWidth,
              height: deviceHeight * 0.5,
              decoration: BoxDecoration(
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
                      child: GestureDetector(
                        onTap: () {
                          print('👑ｵｻﾚﾀﾖｯ${index}');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1.0,
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Icon(
                                      Icons.add_circle_outline,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CustomText(
                                    text: '項目${index}',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
