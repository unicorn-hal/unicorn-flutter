import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:unicorn_flutter/Model/Entity/TutorialTarget/tutorial_target.dart';

class CoachMarkService {
  /// TutorialTargetからターゲットを作成する
  /// [targetList]
  List<TargetFocus> getTargetFocusList({
    required List<TutorialTarget> targetList,
  }) {
    // ターゲットのリストを作成
    List<TargetFocus> targets = [];

    // 受け取ったtargetListを元にtargetsを作成
    for (int i = 0; i < targetList.length; i++) {
      targets.add(
        TargetFocus(
          identify: "target_$i",
          keyTarget: targetList[i].key,
          shape: ShapeLightFocus.RRect,
          paddingFocus: 1.0,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                width: 100,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      targetList[i].title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      targetList[i].description,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    // ターゲットのリストを返す
    return targets;
  }

  /// チュートリアルを表示する
  /// [context] BuildContext
  /// [targets] TargetFocusのリスト
  void showTutorial({
    required BuildContext context,
    required List<TargetFocus> targets,
  }) {
    // チュートリアルの設定
    TutorialCoachMark _tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "スキップ",
      paddingFocus: 1,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print(target);
      },
      onSkip: () {
        return true;
      },
    );

    // チュートリアルを表示
    _tutorialCoachMark.show(context: context);
  }
}
