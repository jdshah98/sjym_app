import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sjym_app/models/api_response.dart';
import 'package:sjym_app/models/name.dart';
import 'package:sjym_app/models/profile.dart';
import 'package:sjym_app/screens/login_screen.dart';
import 'package:sjym_app/widgets/loading_dialog.dart';

import '../../models/image_picker_response.dart';
import '../../models/member.dart';
import '../../provider/cache_provider.dart';
import '../../services/member_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/helper.dart';
import '../../widgets/thumbnail_image.dart';
import 'custom_image_picker.dart';

class AddFamilyMember extends StatefulWidget {
  const AddFamilyMember({super.key, required this.familyId, required this.familyMemberCount});

  final String familyId;
  final int familyMemberCount;

  @override
  State<AddFamilyMember> createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
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

  String _gender = "";
  bool _isMarried = false;
  bool _showInMatrimony = false;

  ImagePickerResponse? _imagePickerResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Member"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
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
                        image: _imagePickerResponse?.thumbnail ?? "",
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
                            imageFilepath: _imagePickerResponse?.filepath,
                          ),
                        ).then((value) {
                          debugPrint('Selected Image: $value');
                          if (value != null) {
                            if (value.localFile == null) {
                              setState(() => _imagePickerResponse = null);
                            } else {
                              setState(() => _imagePickerResponse = value);
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: _mobileNumberController,
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
                          () => _showInMatrimony = value,
                        ),
                        value: _showInMatrimony,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: ElevatedButton(
                  onPressed: _addFamilyMember,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 48),
                  ),
                  child: const Text(
                    "Submit",
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

  void _addFamilyMember() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid Form
      return;
    }

    final Member loggedInMember = CacheProvider().getLoggedInMember();
    if (!loggedInMember.canLogin()) {
      CacheProvider().eraseUserCache();
      Get.offAll(() => const LoginScreen());
    }

    // Show Loading Dialog
    Get.dialog(const LoadingDialog(text: 'Saving Member...'));

    final Member familyMember = Member(
      familyId: loggedInMember.familyId,
      area: loggedInMember.area,
      nativePlace: loggedInMember.nativePlace,
      bloodGroup: _bloodGroupController.value.text.trim(),
      gender: _gender,
      isMarried: _isMarried,
      showInMatrimony: _showInMatrimony,
      name: Name(
        firstName: _firstNameController.value.text.trim(),
        middleName: _middleNameController.value.text.trim(),
        lastName: _lastnameController.value.text.trim(),
      ),
      profile: Profile(
        profilePic: _imagePickerResponse?.filepath ?? '',
        thumbnail: _imagePickerResponse?.thumbnail ?? '',
        mobileNumber: _mobileNumberController.value.text.trim(),
        address: loggedInMember.profile.address,
        email: _emailController.value.text.trim(),
        education: _educationController.value.text.trim(),
        occupation: _occupationController.value.text.trim(),
        officeAddress: _officeAddressController.value.text.trim(),
        officeContact: _officeContactController.value.text.trim(),
        dob: Helper.parseDate(_dobController.value.text.trim())?.microsecondsSinceEpoch,
      ),
      familyOrder: widget.familyMemberCount,
    );

    try {
      ApiResponse<Member> result = await MemberService().saveMember(familyMember);

      if (!result.isError) {
        final List<Member> familyMembers = CacheProvider().getFamilyMembers(widget.familyId);
        familyMembers.add(result.data!);
        CacheProvider().setFamilyMembers(widget.familyId, familyMembers);

        if (_imagePickerResponse != null &&
            _imagePickerResponse?.localFile != null &&
            _imagePickerResponse?.filepath != null) {
          ApiResponse<void> result = await MemberService().setProfileImageUrl(
            _imagePickerResponse!.localFile!,
            _imagePickerResponse!.filepath!,
          );
          if (result.isError && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed to Update Profile Image!! Please try again later!!"),
              backgroundColor: Colors.red,
              duration: Duration(milliseconds: 1000),
            ));

            await Future.delayed(const Duration(milliseconds: 1000));
          }
        }

        // Close Dialog
        Get.back();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Member Added Successfully"),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 2000),
          ));

          // Go Back
          Future.delayed(
            const Duration(milliseconds: 2000),
            () => Get.back(result: 'SUCCESS'),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to Save Member!! Please try again later!!'),
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
