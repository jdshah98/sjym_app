import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.text,
    required this.onSuccess,
    this.onCancel,
  });

  final String text;
  final void Function() onSuccess;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(text, style: const TextStyle(fontSize: 18)),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Get.back(),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: onSuccess,
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
