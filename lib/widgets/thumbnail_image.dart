import 'package:flutter/material.dart';
import 'package:sjym_app/utils/assets.dart';

import '../utils/helper.dart';

class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.fit,
    this.onTap,
  });

  final String image;
  final double width;
  final double height;
  final BoxFit? fit;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: image.isNotEmpty
          ? InkWell(
              onTap: onTap,
              child: Image(
                image: MemoryImage(Helper.decodeImage(image)),
                width: width,
                height: height,
                fit: fit,
              ),
            )
          : Image(
              image: const AssetImage(Assets.avatar),
              width: width,
              height: height,
              fit: fit,
            ),
    );
  }
}
