import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sjym_app/widgets/address_dialog.dart';
import '../../models/address_type.dart';
import '../../services/member_service.dart';
import '../../widgets/loading_dialog.dart';

class SearchMember extends StatefulWidget {
  const SearchMember({super.key});

  @override
  State<SearchMember> createState() => _SearchMemberState();
}

class _SearchMemberState extends State<SearchMember> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _nativePlaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  controller: _mobileNoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                    label: Text('Mobile No'),
                  ),
                ),
              ),
              const Center(
                child: Text('OR', style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Name'),
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: TextFormField(
                        controller: _areaController,
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Area'),
                        ),
                        onTap: () => showDialog<String>(
                          context: context,
                          builder: (context) => AddressDialog(
                            title: 'Select Area',
                            addressType: AddressType.area,
                            selectedValue: _nativePlaceController.value.text,
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
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: TextFormField(
                        controller: _nativePlaceController,
                        keyboardType: TextInputType.none,
                        readOnly: true,
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
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    minimumSize: const Size.fromHeight(48),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  onPressed: _searchMembers,
                  icon: const Icon(Icons.search),
                  label: const Text(
                    'SEARCH',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mobileNoController.dispose();
    _nameController.dispose();
    _areaController.dispose();
    _nativePlaceController.dispose();
    super.dispose();
  }

  bool _isValidMobileNo(mobileNo) {
    if (mobileNo == null || mobileNo.isEmpty) {
      return false;
    }
    if (mobileNo.length != 10) {
      return false;
    }
    return true;
  }

  _searchMembers() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid Form
      return;
    }

    Get.dialog(const LoadingDialog(text: 'Searching...'));

    String mobileNo = _mobileNoController.value.text.trim();

    if (_isValidMobileNo(mobileNo)) {
      // Search Using mobile No
      MemberService().getMembersByMobileNo(mobileNo).then((result) {
        Get.back();

        if (!result.isError) {
          // show member details
        } else {
          log(result.message, name: runtimeType.toString());
          // Show Exception
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
              duration: const Duration(milliseconds: 2000),
            ));
          }
        }
      });
    } else {
      String name = _nameController.value.text.trim();
      String area = _areaController.value.text.trim();
      String nativePlace = _nativePlaceController.value.text.trim();

      MemberService()
          .getUsersByParams(
              name: name.isNotEmpty ? name : null,
              area: area.isNotEmpty ? area : null,
              nativePlace: nativePlace.isNotEmpty ? nativePlace : null)
          .then((result) {
        Get.back();

        if (!result.isError) {
          // show list
        } else {
          log(result.message, name: runtimeType.toString());
          // Show Exception
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
              duration: const Duration(milliseconds: 2000),
            ));
          }
        }
      });
    }
  }
}
