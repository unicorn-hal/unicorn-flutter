import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';

class DoctorChatView extends StatelessWidget {
  const DoctorChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      body: Stack(
        children: [
          ///背景画像を表示する
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: size.width,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          ///チャット表示部
        ],
      ),
    );
  }
}
