import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/HealthCheckup/normal_checkup_controller.dart';
import 'package:unicorn_flutter/Model/Data/AppConfig/app_config_data.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
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
  late NormalCheckupController controller;

  late int selectedIndex;
  bool isSelected = false;
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    controller = NormalCheckupController(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDialogShown && AppConfigData().demoMode) {
      _isDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => const CustomDialog(
            title: Strings.DEMONSTRATION_DIALOG_TITLE,
            bodyText: Strings.DEMONSTRATION_DIALOG_BODY,
            leftButtonText: '確認',
            customButtonCount: 1,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomScaffold(
          isScrollable: true,
          scrollController: controller.scrollController,
          appBar: CustomAppBar(
            title: '通常検診',
            foregroundColor: Colors.white,
            backgroundColor: ColorName.mainColor,
          ),
          body: Column(
            children: [
              /// 進捗バーの表示部
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomText(text: '検診の進捗度'),
                    ),
                    CustomText(
                      text: controller.progressText,
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
                              value: controller.progressValue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        CustomText(text: controller.checkupTitle, fontSize: 20),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.9,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CustomText(text: '当てはまるものを選択してください'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.9,
                child: ListView.builder(
                  itemCount: controller.checkupName.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CheckboxTile(
                      checkboxText: controller.checkupName[index],
                      value: controller.checkupValue[index],
                      onChanged: () {
                        setState(() {
                          isSelected = true;
                          selectedIndex = index;
                          controller.updateCheckupValue(index);
                        });
                      },
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

        /// 次の項目へボタン
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: 250,
              height: 80,
              // todo: controllerで次の項目へ遷移or結果画面へ遷移
              child: CustomButton(
                isFilledColor: true,
                text: '次の項目へ',
                onTap: () {
                  setState(() {
                    if (isSelected == false) {
                      Fluttertoast.showToast(
                        msg: '項目を選択してください',
                        backgroundColor: Colors.red,
                      );
                    } else {
                      isSelected = false;
                      // スクロール位置を一番上に戻す
                      controller.scrollController.jumpTo(0);
                      controller.nextQuestion(selectedIndex);
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
