import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/checkbox_tile.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class NormalCheckupView extends StatefulWidget {
  const NormalCheckupView({super.key});

  @override
  State<NormalCheckupView> createState() => _NormalCheckupViewState();
}

class _NormalCheckupViewState extends State<NormalCheckupView> {
  /// todo: 検診項目をListでもらう
  final String checkupName = '検診項目';
  final bool checkupValue = false;
  // 進捗バーの値　0.0~1.0
  final double progressValue = 0.2;

  //double型の値をパーセントに変換する
  String get progressText => '${(progressValue * 100).toStringAsFixed(0)}%';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomScaffold(
          isScrollable: true,
          body: Column(
            children: [
              /// 進捗バーの表示部
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomText(text: '検診の進捗度'),
              ),
              CustomText(
                text: progressText,
                fontSize: 36,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: size.width * 0.8,
                    height: 24,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(90),
                        backgroundColor: ColorName.shadowGray,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          ColorName.mainColor,
                        ),
                        value: progressValue,
                      ),
                    ),
                  ),
                ),
              ),

              /// 検診項目の表示部
              /// todo: 検診項部分を動的に変更したい
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CustomText(text: 'Q.1 体の調子について', fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: CustomText(text: '当てはまるものを選択してください'),
                ),
              ),
              SizedBox(
                width: size.width * 0.9,
                child: ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CheckboxTile(
                      checkboxText: checkupName,
                      value: checkupValue,
                      onChanged: () {},
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: 250,
              height: 80,
              // todo: controllerで次の項目へ遷移or結果画面へ遷移
              child: CustomButton(
                isFilledColor: true,
                text: '次の項目へ',
                onTap: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
