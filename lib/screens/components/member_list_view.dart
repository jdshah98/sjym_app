import 'package:flutter/material.dart';

import '../../models/member.dart';
import '../../widgets/member_card.dart';

class MemberListView extends StatelessWidget {
  const MemberListView({super.key, required this.members});

  final List<Member> members;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        Member member = members.elementAt(index);
        return MemberCard(member: member);
      },
    );
  }
}
