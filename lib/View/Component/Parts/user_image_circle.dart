import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../CustomWidget/custom_indicator.dart';

class UserImageCircle extends StatelessWidget {
  const UserImageCircle({
    super.key,
    required this.imageSize,
    this.localImage,
    this.imageUrl,
    this.onTap,
  });

  final double imageSize;
  final Image? localImage;
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
            //ローカル画像で指定した場合はそっちを優先、ない場合はURLから画像を表示
            child: localImage != null
                ? localImage!
                : imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        placeholder: (context, url) => const CustomIndicator(),
                        errorWidget: (context, url, error) =>
                            Assets.images.icons.defaultUserIcon.image(
                          fit: BoxFit.cover,
                        ),
                      )
                    // imageUrlがnullの場合はデフォルトの画像を表示
                    : Assets.images.icons.defaultUserIcon.image(
                        fit: BoxFit.cover,
                      ),
          ),
        ),
      ),
    );
  }
}
