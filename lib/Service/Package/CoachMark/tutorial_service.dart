import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:unicorn_flutter/Model/Entity/TutorialTarget/tutorial_target.dart';

class TutorialService {
  late TutorialCoachMark _tutorialCoachMark;
  List<TargetFocus> targets = [];

  ///　必ずinitializeTargetsを呼び出してからshowTutorialを呼び出す
  ///　context: BuildContextを渡す

  /// ターゲットを初期化する
  void initializeTargets({
    required List<TutorialTarget> targetList,
  }) {
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
  }

  /// チュートリアルを表示する
  void showTutorial({
    required BuildContext context,
  }) {
    _tutorialCoachMark = TutorialCoachMark(
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
    )..show(
        context: context,
      );
  }
}
