import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/address_type.dart';
import '../../models/address_statistics.dart';
import '../../models/family_stat.dart';
import 'paged_member_list_view.dart';
import 'statistics_card.dart';
import '../../services/address_service.dart';
import '../../services/member_service.dart';
import '../../utils/app_colors.dart';

class NativeGridView extends StatelessWidget {
  const NativeGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<AddressStatistics?>(
      future: AddressService().getNativePlaceStatistics(),
      waiting: (context) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      },
      builder: (context, value) {
        final AddressStatistics nativePlaceStatistics = value ?? AddressStatistics(AddressType.native);
        return GridView.builder(
          itemCount: nativePlaceStatistics.stats.keys.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            final String native = nativePlaceStatistics.stats.keys.elementAt(index);
            return InkWell(
              onTap: () => _loadMembersByNative(native),
              child: StatisticsCard(
                text: native,
                familyStat: nativePlaceStatistics.stats[native] ?? FamilyStat(),
              ),
            );
          },
        );
      },
    );
  }

  void _loadMembersByNative(String native) => Get.to(
        () => PagedMemberListView(
          function: MemberService().getMembersByNativePlace,
          searchParam: native,
        ),
      );
}
