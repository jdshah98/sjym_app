import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/api_response.dart';
import '../../models/member.dart';
import '../../provider/cache_provider.dart';
import '../../widgets/member_detail_view.dart';
import '../../services/member_service.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/loading_dialog.dart';
import 'edit_member.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key, required this.member, required this.updateState});

  final Member member;
  final void Function(List<Member> familyMembers) updateState;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              "Action",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            height: 0,
          ),
          const SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              Get.off(MemberDetailView(member: widget.member));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.visibility),
                  ),
                  Text(
                    "View",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _editMember(widget.member),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.edit),
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          if (!widget.member.isMainMember()) ...[
            InkWell(
              onTap: () => Get.dialog(
                ConfirmDialog(
                  text: "Are you sure you want to delete member?",
                  onSuccess: () {
                    Get.back();
                    _deleteMember(widget.member);
                  },
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.delete),
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
          InkWell(
            onTap: () => Get.back(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.close),
                  ),
                  Text(
                    "Cancel",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _editMember(Member member) async {
    final bool result = (await Get.off<bool>(EditFamilyMember(member: member))) ?? false;
    if (result) {
      widget.updateState(CacheProvider().getFamilyMembers(member.familyId));
    }
  }

  Future<void> _deleteMember(Member member) async {
    // Show Loading Dialog
    Get.dialog(const LoadingDialog(text: "Deleting Member..."));

    ApiResponse<void> result = await MemberService().deleteMember(member);

    if (mounted) {
      // Close Dialog
      Get.back();

      if (!result.isError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.green,
          duration: const Duration(milliseconds: 2000),
        ));

        List<Member> familyMembers = CacheProvider().getFamilyMembers(member.familyId);
        familyMembers.removeWhere((element) => element.uid == widget.member.uid);
        widget.updateState(familyMembers);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to Delete Member!!'),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 2000),
        ));
      }
    }
  }
}
