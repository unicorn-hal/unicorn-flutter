import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/Chat/department_badges.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class DoctorPageView extends StatelessWidget {
  DoctorPageView({super.key});

  final imageUrl = 'https://picsum.photos/200/300';
  final String doctorName = '長谷川';
  final List<String> depermentList = [
    '内科',
    '外科',
    '整形外科',
    // '皮膚科',
    // '内科',
    // '外科',
    // '整形外科',
    // '皮膚科',
  ];

  final String chatSupportHours = '平日9:00~12:00';
  final String callSupportHours = '平日14:00~22:00';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      isScrollable: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// 医師画像表示部
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: UserImageCircle(
                  imageSize: 200,
                  imageUrl: imageUrl,
                ),
              ),
            ),

            /// 医師名・科目表示部
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    text: doctorName,
                    fontSize: 26,
                  ),
                  const CustomText(
                    text: '先生',
                    fontSize: 20,
                  ),
                ],
              ),
            ),

            /// 科目カード表示部
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 10,
                ),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // todo: ここで科目リストを表示する
                    for (final department in depermentList)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        child: DepartmentBadge(
                          name: department,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            /// 通話予約&チャット画面へ遷移するボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      // todo: チャット画面へ遷移
                    },
                    child: Container(
                      width: 160,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: ColorName.shadowGray,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            color: ColorName.mainColor,
                            size: 40,
                          ),
                          CustomText(
                            text: 'チャット',
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      // todo: チャット画面へ遷移
                    },
                    child: Container(
                      width: 160,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: ColorName.shadowGray,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call,
                            color: ColorName.mainColor,
                            size: 40,
                          ),
                          CustomText(
                            text: '通話予約',
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SpacerAndDivider(),
            ),

            /// 医師情報表示部
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: CustomText(
                  text: 'この医師について',
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              width: size.width * 0.9,
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorName.shadowGray,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: CustomText(
                      text: '対応可能時間',
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: CustomText(text: 'チャット: $chatSupportHours'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: CustomText(
                      text: '通話: $callSupportHours',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
