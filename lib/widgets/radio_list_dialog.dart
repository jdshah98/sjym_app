import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';

class RadioListDialog extends StatefulWidget {
  const RadioListDialog({
    super.key,
    required this.title,
    required this.entries,
    required this.selectedValue,
  });

  final String title;
  final List<String> entries;
  final String selectedValue;

  @override
  State<RadioListDialog> createState() => _RadioListDialogState();
}

class _RadioListDialogState extends State<RadioListDialog> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();

    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: AppColors.primaryColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    widget.title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.entries
                        .map(
                          (entry) => RadioListTile(
                            title: Text(entry),
                            value: entry,
                            groupValue: _selectedValue,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedValue = value;
                                });
                              }
                            },
                          ),
                        )
                        .toList()),
              ),
            ),
            IntrinsicHeight(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: AppColors.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Cancel'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: TextButton(
                          onPressed: () => Get.back(result: _selectedValue),
                          child: Text(
                            'Ok'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
