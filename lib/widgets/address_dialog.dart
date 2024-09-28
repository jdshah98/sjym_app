import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import '../models/address_statistics.dart';
import '../models/address_type.dart';
import '../services/address_service.dart';
import 'radio_list_dialog.dart';

import '../utils/app_colors.dart';

class AddressDialog extends StatelessWidget {
  const AddressDialog({
    super.key,
    required this.title,
    required this.addressType,
    required this.selectedValue,
  });

  final String title;
  final AddressType addressType;
  final String selectedValue;

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<AddressStatistics?>(
      future: AddressService().getAddressStatistics(addressType),
      waiting: (context) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      ),
      builder: (context, value) {
        final AddressStatistics areaStatistics = value ?? AddressStatistics(addressType);
        return RadioListDialog(
          title: title,
          selectedValue: selectedValue,
          entries: areaStatistics.stats.keys.toList(),
        );
      },
    );
  }
}
