import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_indicator.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

class UserImageCircle extends StatelessWidget {
  const UserImageCircle({
    super.key,
    required this.imageSize,
    this.imagePath,
    this.onTap,
  });

  final double imageSize;
  final String? imagePath;
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
            child: imagePath != null
                ? CachedNetworkImage(
                    imageUrl: imagePath!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CustomIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
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
