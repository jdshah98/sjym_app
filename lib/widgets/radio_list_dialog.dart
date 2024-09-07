import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final TextEditingController _textEditingController = TextEditingController();

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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: TextFormField(
                        enabled: _selectedValue.compareTo("other") == 0,
                        keyboardType: TextInputType.name,
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "New Value",
                        ),
                      ),
                    ),
                    ...widget.entries.map(
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
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_selectedValue.compareTo("other") == 0) {
                        if (_textEditingController.value.text.isNotEmpty) {
                          Get.back(result: _textEditingController.value.text.trim());
                        } else {
                          Get.back(result: _selectedValue);
                        }
                      } else {
                        Get.back(result: _selectedValue);
                      }
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
