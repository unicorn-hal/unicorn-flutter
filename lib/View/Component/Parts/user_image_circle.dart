import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_indicator.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

class UserImageCircle extends StatelessWidget {
  const UserImageCircle({
    super.key,
    required this.imageSize,
    this.imageUrl,
    this.onTap,
  });

  final double imageSize;
  final String? imageUrl;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: SizedBox(
        width: imageSize,
        height: imageSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(imageSize / 2),
          child: FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.antiAlias,
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    placeholder: (context, url) => const CustomIndicator(),
                    errorWidget: (context, url, error) =>
                        Assets.images.icons.defaultUserIcon.image(
                      fit: BoxFit.cover,
                    ),
                  )
                : Assets.images.icons.defaultUserIcon.image(
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
