import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sjym_app/models/member.dart';

import 'profile_pic_viewer.dart';
import 'thumbnail_image.dart';

class MemberDetailView extends StatelessWidget {
  const MemberDetailView({super.key, required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: Center(
                child: ThumbnailImage(
                  image: member.profile.thumbnail,
                  width: 120,
                  height: 120,
                  onTap: () => Get.to(ProfilePicViewer(
                    profileImageFilepath: member.profile.profilePic,
                  )),
                ),
              ),
            ),
            _TextView(
              label: 'Name',
              content: member.name.toString().toUpperCase(),
            ),
            _TextView(
              label: 'Mobile',
              content: member.profile.mobileNumber,
            ),
            _TextView(
              label: 'D.O.B',
              content: member.profile.getDateOfBirth(),
            ),
            _TextView(
              label: 'Gender',
              content: member.gender.toUpperCase(),
            ),
            _TextView(
              label: 'Blood Group',
              content: member.bloodGroup.toUpperCase(),
            ),
            _TextView(
              label: 'Marital Status',
              content: member.isMarried ? 'Married' : 'Unmarried',
            ),
            _TextView(
              label: 'Education',
              content: member.profile.education,
            ),
            _TextView(
              label: 'Occupation',
              content: member.profile.occupation,
            ),
            _TextView(
              label: 'Office Contact',
              content: member.profile.officeContact,
            ),
            _TextView(
              label: 'Office Address',
              content: member.profile.officeAddress,
            ),
          ],
        ),
      ),
    );
  }
}

class _TextView extends StatelessWidget {
  const _TextView({required this.label, required this.content});

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
