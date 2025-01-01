import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sjym_app/screens/create_member_screen.dart';
import 'package:sjym_app/screens/manage_requests_screen.dart';
import 'package:sjym_app/screens/search_member_screen.dart';
import 'package:sjym_app/screens/update_advertisement_screen.dart';
import 'package:sjym_app/utils/app_colors.dart';
import 'package:sjym_app/utils/helper.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  static final List _items = [
    {
      "text": "Create New Member",
      "onTap": () => Get.to(() => const CreateMemberScreen()),
      "color": Colors.deepPurple,
      "icon": Icons.person_add_alt,
    },
    {
      "text": "Search Member",
      "onTap": () => Get.to(() => const SearchMemberScreen()),
      "color": Colors.green,
      "icon": Icons.person_search,
    },
    {
      "text": "Update Advertisement",
      "onTap": () => Get.to(() => const UpdateAdvertisementScreen()),
      "color": Colors.indigo,
      "icon": Icons.update,
    },
    {
      "text": "Manage Requests",
      "onTap": () => Get.to(() => const ManageRequestsScreen()),
      "color": Colors.pink,
      "icon": Icons.manage_history,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: _items[index]["onTap"],
            title: Text(
              _items[index]["text"],
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.primaryColor,
              ),
            ),
            leading: Icon(
              _items[index]["icon"],
              size: 28,
              color: Helper.getRandomColor(),
            ),
          );
        },
      ),
    );
  }
}
