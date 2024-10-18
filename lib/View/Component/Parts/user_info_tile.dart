import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({
    super.key,
    required this.onTap,
    required this.userName,
    required this.description,
    required this.image,
    this.tileColor = Colors.white,
  });

  /// todo: UserModelができたらここに引数を追加する
  ///
  final String userName;
  final String description;
  final Color tileColor;
  final Image image;
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
              SizedBox(
                width: 50,
                height: 50,
                child: UserImageCircle(
                  imageSize: 50,
                  image: image,
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
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(text: 'のりたしおき'),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    height: 20,
                    child: const Align(
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
