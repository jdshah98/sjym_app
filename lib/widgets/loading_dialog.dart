import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LoadingDialog extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding;
  final Color? foregroundColor;

  const LoadingDialog({
    super.key,
    required this.text,
    EdgeInsetsGeometry? padding,
    Color? foregroundColor,
  })  : padding = padding ?? const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        foregroundColor = foregroundColor ?? AppColors.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: foregroundColor),
            const SizedBox(height: 16),
            Text(text, style: TextStyle(color: foregroundColor, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
