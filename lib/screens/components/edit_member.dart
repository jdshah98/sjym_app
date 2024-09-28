import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/api_response.dart';
import '../../models/image_picker_response.dart';
import '../../models/member.dart';
import '../../models/name.dart';
import '../../provider/cache_provider.dart';
import '../../services/member_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/helper.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/thumbnail_image.dart';
import 'custom_image_picker.dart';

class EditFamilyMember extends StatefulWidget {
  const EditFamilyMember({super.key, required this.member});

  final Member member;

  @override
  State<EditFamilyMember> createState() => _EditFamilyMemberState();
}

class _EditFamilyMemberState extends State<EditFamilyMember> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _officeContactController = TextEditingController();
  final TextEditingController _officeAddressController = TextEditingController();

  late String _gender;
  late bool _isMarried;
  late bool _showProfileInMatrimony;
  late Member _member;

  @override
  void initState() {
    super.initState();

    _member = widget.member;

    _gender = _member.gender;
    _isMarried = _member.isMarried;
    _showProfileInMatrimony = _member.showInMatrimony;

    _firstNameController.text = _member.name.firstName;
    _middleNameController.text = _member.name.middleName;
    _lastnameController.text = _member.name.lastName;
    _mobileNumberController.text = _member.profile.mobileNumber;
    _dobController.text = Helper.getFormattedDate(microseconds: _member.profile.dob) ?? 'NA';
    _bloodGroupController.text = _member.bloodGroup;
    _emailController.text = _member.profile.email;
    _educationController.text = _member.profile.education;
    _occupationController.text = _member.profile.occupation;
    _officeContactController.text = _member.profile.officeContact;
    _officeAddressController.text = _member.profile.officeAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Member'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        actions: [
          TextButton(
            onPressed: _updateMember,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Update',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ThumbnailImage(
                        image: _member.profile.thumbnail,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      FloatingActionButton.small(
                        onPressed: () => showModalBottomSheet<ImagePickerResponse>(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          builder: (context) => CustomImagePicker(
                            imageFilepath: widget.member.profile.profilePic,
                          ),
                        ).then((value) {
                          debugPrint('Selected Image: $value');
                          if (value != null) {
                            if (value.localFile == null) {
                              setState(() {
                                _member.profile.thumbnail = '';
                                _member.profile.profilePic = '';
                              });
                            } else {
                              setState(() {
                                _member.profile.thumbnail = value.thumbnail ?? '';
                                _member.profile.profilePic = value.filename ?? '';
                              });
                            }
                          }
                        }),
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: const CircleBorder(),
                        child: const Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('First Name'),
                    hintText: 'Enter First Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First Name is Required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _middleNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Middle Name'),
                    hintText: 'Enter Middle Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _lastnameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Last Name'),
                    hintText: 'Enter Last Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last Name is Required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _mobileNumberController,
                  enabled: !_member.isMainMember(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Mobile No'),
                    hintText: 'Enter Mobile No',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mobile No is Required';
                    }
                    if (value.length != 10) {
                      return 'Mobile No must be 10 digits long';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.none,
                  controller: _dobController,
                  onTap: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((value) {
                    if (value != null) {
                      _dobController.text = Helper.getFormattedDate(datetime: value) ?? 'NA';
                    }
                  }),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('D.O.B.'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: RadioListTile(
                        title: const Text('Male'),
                        value: 'male',
                        selected: _gender == 'male',
                        groupValue: _gender,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _gender = value;
                            });
                          }
                        },
                      ),
                    ),
                    Flexible(
                      child: RadioListTile(
                        title: const Text('Female'),
                        value: 'female',
                        selected: _gender == 'female',
                        groupValue: _gender,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _gender = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownMenu<String>(
                      menuHeight: 300,
                      width: MediaQuery.of(context).size.width - 32,
                      label: const Text('Select Blood Group'),
                      controller: _bloodGroupController,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: '', label: 'Select Blood Group'),
                        DropdownMenuEntry(value: 'A+', label: 'A Positive'),
                        DropdownMenuEntry(value: 'A-', label: 'A Negative'),
                        DropdownMenuEntry(value: 'B+', label: 'B Positive'),
                        DropdownMenuEntry(value: 'B-', label: 'B Negative'),
                        DropdownMenuEntry(value: 'AB+', label: 'AB Positive'),
                        DropdownMenuEntry(value: 'AB-', label: 'AB Negative'),
                        DropdownMenuEntry(value: 'O+', label: 'O Positive'),
                        DropdownMenuEntry(value: 'O-', label: 'O Negative'),
                      ],
                      onSelected: (value) {
                        if (value != null) {
                          _bloodGroupController.text = value;
                        }
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Is Married',
                      style: TextStyle(fontSize: 18),
                    ),
                    Switch(
                      onChanged: (value) => setState(() => _isMarried = value),
                      value: _isMarried,
                    ),
                  ],
                ),
              ),
              if (!_isMarried) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Show Profile In Matrimony',
                        style: TextStyle(fontSize: 18),
                      ),
                      Switch(
                        onChanged: (value) => setState(
                          () => _showProfileInMatrimony = value,
                        ),
                        value: _showProfileInMatrimony,
                      ),
                    ],
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Email'),
                    hintText: 'Enter Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _educationController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Education'),
                    hintText: 'Enter Education',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _occupationController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Occupation'),
                    hintText: 'Enter Occupation',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _officeContactController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Office Contact'),
                    hintText: 'Enter Office Contact',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _officeAddressController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Office Address'),
                    hintText: 'Enter Office Address',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _isFormChanged() {
    if (_member.name.firstName.trim() != _firstNameController.value.text.trim()) {
      return true;
    }
    if (_member.name.middleName.trim() != _middleNameController.value.text.trim()) {
      return true;
    }
    if (_member.name.lastName.trim() != _lastnameController.value.text.trim()) {
      return true;
    }
    if (_member.profile.mobileNumber.trim() != _mobileNumberController.value.text.trim()) {
      return true;
    }
    if (_member.profile.dob == null) {
      if (_dobController.value.text.trim().isNotEmpty) {
        return true;
      }
    } else {
      String memberDob = Helper.getFormattedDate(microseconds: _member.profile.dob!) ?? 'NA';
      if (_dobController.value.text.trim() != memberDob) {
        return true;
      }
    }
    if (_member.gender != _gender) {
      return true;
    }
    if (_member.bloodGroup.trim() != _bloodGroupController.value.text.trim()) {
      return true;
    }
    if (_member.isMarried != _isMarried) {
      return true;
    }
    if (_member.showInMatrimony != _showProfileInMatrimony) {
      return true;
    }
    if (_member.profile.email.trim() != _emailController.value.text.trim()) {
      return true;
    }
    if (_member.profile.education.trim() != _educationController.value.text.trim()) {
      return true;
    }
    if (_member.profile.occupation.trim() != _occupationController.value.text.trim()) {
      return true;
    }
    if (_member.profile.officeContact.trim() != _officeContactController.value.text.trim()) {
      return true;
    }
    if (_member.profile.officeAddress.trim() != _officeAddressController.value.text.trim()) {
      return true;
    }
    return false;
  }

  _isProfileLimitReached() {
    final DateTime lastProfileUpdated = Helper.getDate(_member.lastUpdated);
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));
    if (lastProfileUpdated.isAfter(yesterday) && lastProfileUpdated.day == today.day) {
      return true;
    }
    return false;
  }

  _updateMember() async {
    if (!_formKey.currentState!.validate() && !_isFormChanged()) {
      return;
    }

    if (_isProfileLimitReached()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profile can be updated only once within 24 hours!!'),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 2000),
      ));
      return;
    }

    // Show Loading Dialog
    Get.dialog(const LoadingDialog(text: 'Updating Profile...'));

    Member updatedMember = Member();
    updatedMember.name = Name(
      firstName: _firstNameController.value.text.trim(),
      middleName: _middleNameController.value.text.trim(),
      lastName: _lastnameController.value.text.trim(),
    );
    updatedMember.profile.mobileNumber = _mobileNumberController.value.text.trim();
    if (_dobController.value.text.trim().isNotEmpty && _dobController.value.text.compareTo('NA') != 0) {
      updatedMember.profile.dob = Helper.parseDate(_dobController.value.text.trim()).microsecondsSinceEpoch;
    }
    updatedMember.bloodGroup = _bloodGroupController.value.text;
    updatedMember.gender = _gender;
    updatedMember.isMarried = _isMarried;
    if (!updatedMember.isMarried) {
      updatedMember.showInMatrimony = _showProfileInMatrimony;
    } else {
      updatedMember.showInMatrimony = false;
    }
    updatedMember.profile.email = _emailController.value.text;
    updatedMember.profile.education = _educationController.value.text;
    updatedMember.profile.occupation = _occupationController.value.text;
    updatedMember.profile.officeContact = _officeContactController.value.text;
    updatedMember.profile.officeAddress = _officeAddressController.value.text;

    try {
      ApiResponse<Member> result = await MemberService().updateMember(updatedMember);

      if (!result.isError) {
        updatedMember = result.data ?? updatedMember;

        List<Member> familyMembers = CacheProvider().getFamilyMembers(updatedMember.familyId);
        int index = familyMembers.indexWhere((element) => element.uid == updatedMember.uid);
        familyMembers[index] = updatedMember;
        CacheProvider().setFamilyMembers(familyMembers, updatedMember.familyId);

        if (mounted) {
          Get.back();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 2000),
          ));

          // Go Back
          Future.delayed(
            const Duration(milliseconds: 2000),
            () => Get.back<bool>(result: true),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to Update Profile!! Please try again later!!'),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 2000),
          ));
        }
      }
    } catch (err) {
      log(err.toString(), error: err, name: runtimeType.toString());
      debugPrint('Exception: ${err.toString()}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong!! Please try again later!!'),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 2000),
        ));
      }
    }
  }
}
