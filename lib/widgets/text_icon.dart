import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  const TextIcon({
    super.key,
    required this.width,
    required this.height,
    required this.icon,
    required this.text,
  });

  final double width;
  final double height;
  final Icon icon;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, text],
      ),
    );
  }
}
