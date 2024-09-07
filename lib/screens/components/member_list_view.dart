import 'package:flutter/material.dart';
import 'package:sjym_app/models/member.dart';
import 'package:sjym_app/widgets/member_card.dart';

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
