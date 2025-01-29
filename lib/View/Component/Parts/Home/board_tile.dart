import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

import '../../CustomWidget/custom_indicator.dart';

class BoardTile extends StatelessWidget {
  const BoardTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    this.onTap,
    this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String content;
  final Function? onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        width: size.width * 0.9,
        constraints: const BoxConstraints(
          maxHeight: 130,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: FittedBox(
                  clipBehavior: Clip.antiAlias,
                  fit: BoxFit.cover,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          placeholder: (context, url) =>
                              const CustomIndicator(),
                          errorWidget: (context, url, error) =>
                              Assets.images.icons.defaultImageIcon.image(
                            fit: BoxFit.cover,
                          ),
                        )
                      : Assets.images.icons.defaultImageIcon.image(
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8),
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
                        text: subtitle,
                        fontSize: 10,
                        color: ColorName.textGray,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    SizedBox(
                      width: size.width * 0.6,
                      child: CustomText(
                        text: content,
                        fontSize: 12,
                        color: ColorName.textGray,
                        textOverflow: TextOverflow.ellipsis,
                        maxLine: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
