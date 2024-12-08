import 'package:flutter/material.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class ImageBanner extends StatelessWidget {
  const ImageBanner({
    super.key,
    required this.image,
    required this.onTap,
  });
  final Image image;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => onTap.call(),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: ColorName.shadowGray,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ]),
          child: image,
        ),
      ),
    );
  }
}
