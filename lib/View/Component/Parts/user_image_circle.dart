import 'package:flutter/cupertino.dart';

class UserImageCircle extends StatelessWidget {
  const UserImageCircle({
    super.key,
    required this.imageSize,
    required this.imagePath,
    required this.onTap,
  });

  final double imageSize;
  final String imagePath;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: imageSize,
        height: imageSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(imageSize / 2),
          child: FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.antiAlias,
            child: Image.network(imagePath),
          ),
        ),
      ),
    );
  }
}
