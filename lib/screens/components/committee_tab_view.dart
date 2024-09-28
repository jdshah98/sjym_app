import 'dart:developer';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';

import '../../models/committee_type.dart';
import '../../models/member.dart';
import '../../services/member_service.dart';
import '../../utils/app_colors.dart';
import 'committee_member_card.dart';

class CommitteeTabView extends StatelessWidget {
  const CommitteeTabView({super.key, required this.committeeType});

  final CommitteeType committeeType;

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<List<Member>>(
      future: MemberService().getCommitteeMembers(committeeType),
      waiting: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      ),
      builder: (context, final value) {
        final List<Member> members = value ?? [];
        return SingleChildScrollView(
          child: Column(
            children: members
                .map((final member) => CommitteeMemberCard(
                      committeeType: committeeType,
                      member: member,
                    ))
                .toList(),
          ),
        );
      },
      error: (context, final error, final stackTrace) {
        log(error.toString(), error: error, name: runtimeType.toString());
        debugPrint(error.toString());
        debugPrint(stackTrace?.toString());
        return const SizedBox.shrink();
      },
    );
  }
}
