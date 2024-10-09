import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class BoardTile extends StatelessWidget {
  const BoardTile({
    super.key,
    required this.title,
    required this.content,
    this.onTap,
    this.imageUrl,
  });

  final String title;
  final String content;
  final Function? onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onTap,
      child: imageUrl == null

          /// imageUrlがnullの場合はContainerを表示
          ? Container(
              width: size.width * 0.9,
              constraints: const BoxConstraints(
                maxHeight: 130,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      child: CustomText(
                        text: title,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.8,
                      child: CustomText(
                        text: content,
                        fontSize: 12,
                        color: ColorName.textGray,
                        textOverflow: TextOverflow.ellipsis,
                        maxLine: 5,
                      ),
                    ),
                  ],
                ),
              ),
            )

          /// imageUrlがある場合は画像付きContainerを表示
          : Container(
              width: size.width * 0.9,
              constraints: const BoxConstraints(
                maxHeight: 130,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.grey,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: size.width * 0.6,
                              child: CustomText(
                                text: title,
                                fontSize: 14,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.6,
                              child: CustomText(
                                text: content,
                                fontSize: 12,
                                color: ColorName.textGray,
                                textOverflow: TextOverflow.ellipsis,
                                maxLine: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
