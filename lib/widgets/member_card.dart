import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import 'member_detail_view.dart';

import '../models/member.dart';
import '../services/member_service.dart';
import 'thumbnail_image.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    super.key,
    required this.member,
    this.isFamilyList = false,
  });

  final Member member;
  final bool isFamilyList;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      surfaceTintColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ThumbnailImage(
                    image: member.profile.thumbnail,
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 174,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name.toString().capitalize!,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            member.getAddress(),
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 18,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            member.profile.mobileNumber,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!isFamilyList) ...[
                  ElevatedButton(
                    onPressed: () => Get.to(_FamilyMemberListView(member: member)),
                    child: const Text('View Family'),
                  ),
                ],
                ElevatedButton(
                  onPressed: () => Get.to(MemberDetailView(member: member)),
                  child: const Text('View Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilyMemberListView extends StatelessWidget {
  const _FamilyMemberListView({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members'),
      ),
      body: AsyncBuilder<List<Member>>(
        future: MemberService().getFamilyMembers(member.familyId),
        waiting: (context) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        },
        builder: (context, value) {
          List<Member> familyMembers = value ?? [];
          return ListView.builder(
            itemCount: familyMembers.length,
            itemBuilder: (context, index) => MemberCard(
              member: familyMembers[index],
              isFamilyList: true,
            ),
          );
        },
      ),
    );
  }
}
