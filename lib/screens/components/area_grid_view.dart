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

class AreaGridView extends StatelessWidget {
  const AreaGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<AddressStatistics?>(
      future: AddressService().getAreaStatistics(),
      waiting: (context) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      },
      builder: (context, value) {
        final AddressStatistics areaStatistics = value ?? AddressStatistics(AddressType.area);
        return GridView.builder(
          itemCount: areaStatistics.stats.keys.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            final String area = areaStatistics.stats.keys.elementAt(index);
            return InkWell(
              onTap: () => _loadMembersByArea(area),
              child: StatisticsCard(
                text: area,
                familyStat: areaStatistics.stats[area] ?? FamilyStat(),
              ),
            );
          },
        );
      },
    );
  }

  void _loadMembersByArea(String area) => Get.to(
        () => PagedMemberListView(
          function: MemberService().getMembersByArea,
          searchParam: area,
        ),
      );
}
