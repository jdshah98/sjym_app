import 'package:async_builder/async_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/assets.dart';

import '../services/member_service.dart';

class ProfilePicViewer extends StatelessWidget {
  const ProfilePicViewer({super.key, required this.profileImageFilepath});

  final String profileImageFilepath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncBuilder<String?>(
        future: MemberService().getProfileImageUrl(profileImageFilepath),
        waiting: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        builder: (context, value) {
          if (value == null) {
            return const Image(
              image: AssetImage(Assets.avatar),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            );
          }
          return Center(
            child: CachedNetworkImage(
              imageUrl: value,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => Get.back(),
        backgroundColor: Theme.of(context).colorScheme.error,
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
