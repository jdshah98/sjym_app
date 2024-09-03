import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:sjym_app/models/committee_type.dart';
import 'package:sjym_app/models/member.dart';
import 'package:sjym_app/utils/app_colors.dart';

import '../../widgets/thumbnail_image.dart';

class CommitteeMemberCard extends StatelessWidget {
  const CommitteeMemberCard({super.key, required this.committeeType, required this.member});

  final CommitteeType committeeType;
  final Member member;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ThumbnailImage(
                image: member.profile.thumbnail,
                width: 50,
                height: 50,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 124,
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
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primaryColor,
                    ),
                    child: Text(
                      member.getCommitteeDesignation(committeeType).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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
