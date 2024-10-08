import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({
    super.key,
    required this.onTap,
    this.tileColor = Colors.white,
  });

  /// UserModelができたらここに引数を追加する

  final Color tileColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: size.width,
        height: 70,
        color: tileColor,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              /// れいくんの作業が終わったらここに挿入する。高さ・幅 > 50
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),

              /// ここものちに変更する
              const SizedBox(
                width: 4.0,
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.5,
                    height: 30,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(text: 'のりたしおき'),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    height: 20,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text:
                            'テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト',
                        color: Colors.grey,
                        fontSize: 12,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
