import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String text;
  final Color? foregroundColor;

  const LoadingWidget({
    super.key,
    required this.text,
    Color? foregroundColor,
  }) : foregroundColor = foregroundColor ?? AppColors.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: foregroundColor),
            const SizedBox(height: 8),
            Text(text, style: TextStyle(color: foregroundColor, fontSize: 28)),
          ],
        ),
      ),
    );
  }
}
