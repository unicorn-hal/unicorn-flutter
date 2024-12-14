import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({
    super.key,
    required this.onTap,
    required this.userName,
    required this.description,
    this.imageUrl,
    this.localImage,
    this.tileColor = Colors.white,
    this.badge,
  });

  /// todo: UserModelができたらここに引数を追加する
  ///
  final String userName;
  final String description;
  final Color tileColor;
  final String? imageUrl;
  final Image? localImage;
  final Function onTap;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => onTap(),
          child: Container(
            width: size.width,
            height: 70,
            color: tileColor,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: 10,
                right: 4,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: UserImageCircle(
                      imageSize: 50,
                      imageUrl: imageUrl,
                      localImage: localImage,
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
                          child: CustomText(text: userName),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.8,
                        height: 20,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: description,
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
        ),
        // バッジがある場合は右寄せに表示
        if (badge != null)
          Positioned(
            top: 0,
            bottom: 0,
            right: 10,
            child: Center(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(2.0),
                  ),
                ),
                width: 30,
                height: 30,
                child: badge!,
              ),
            ),
          ),
      ],
    );
  }
}
