import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/address_type.dart';
import '../widgets/address_dialog.dart';
import '../models/member.dart';
import '../provider/cache_provider.dart';
import 'components/custom_bottom_sheet.dart';
import '../services/member_service.dart';
import '../widgets/thumbnail_image.dart';

import '../utils/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _nativePlaceController = TextEditingController();

  bool _isLoaded = false;
  late Member _member;

  List<Member> _familyMembers = [];

  @override
  void initState() {
    super.initState();

    _member = CacheProvider().getLoggedInMember();

    MemberService().getFamilyMembers(_member.familyId).then((familyMembers) {
      setState(() {
        _familyMembers = familyMembers;
        _isLoaded = true;
      });
    });

    _addressController.text = _member.profile.address;
    _areaController.text = _member.area;
    _nativePlaceController.text = _member.nativePlace;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Manage Profile'),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  minLines: 1,
                  maxLines: 4,
                  controller: _addressController,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                    label: Text('Residential Address'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.none,
                  controller: _areaController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Area'),
                  ),
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (context) => AddressDialog(
                      title: 'Select Area',
                      addressType: AddressType.area,
                      selectedValue: _areaController.value.text,
                    ),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _areaController.text = value;
                      });
                    }
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.none,
                  controller: _nativePlaceController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Native'),
                  ),
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (context) => AddressDialog(
                      title: 'Select Native Place',
                      addressType: AddressType.native,
                      selectedValue: _nativePlaceController.value.text,
                    ),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _nativePlaceController.text = value;
                      });
                    }
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    minimumSize: const Size.fromHeight(48),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  onPressed: _updateProfile,
                  child: const Text('UPDATE', style: TextStyle(fontSize: 16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 4,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Family Members',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _addMember,
                                    icon: const Icon(Icons.add),
                                    label: const Text('Member'),
                                  )
                                ],
                              ),
                            ),
                          ] +
                          (_isLoaded
                              ? _familyMembers.map(
                                  (familyMember) {
                                    return _FamilyMemberCard(
                                      familyMember: familyMember,
                                      onTap: _onFamilyMemberTap,
                                    );
                                  },
                                ).toList()
                              : [
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {}

  Future<void> _addMember() async {}

  void _onFamilyMemberTap(Member familyMember) {
    showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      isScrollControlled: true,
      builder: (modalContext) => CustomBottomSheet(
        member: familyMember,
        updateState: (List<Member> familyMembers) {
          // Close All Dialogs
          Get.back(closeOverlays: true);
          setState(() {
            _familyMembers = familyMembers;
          });
          CacheProvider().setFamilyMembers(familyMembers, _member.familyId);
        },
      ),
    );
  }
}

class _FamilyMemberCard extends StatelessWidget {
  const _FamilyMemberCard({required this.familyMember, required this.onTap});

  final Member familyMember;
  final void Function(Member familyMember) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => onTap(familyMember),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Center(
                  child: ThumbnailImage(
                    image: familyMember.profile.thumbnail,
                    width: 45,
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 10, height: 60),
              Expanded(
                child: Text(
                  familyMember.name.toString().capitalize!,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryColor,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
