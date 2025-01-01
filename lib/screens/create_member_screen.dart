import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sjym_app/models/committee_designation.dart';
import 'package:sjym_app/models/committee_type.dart';
import 'package:sjym_app/models/register_request.dart';
import 'package:sjym_app/services/auth_service.dart';

import '../../models/address_statistics.dart';
import '../../models/api_response.dart';
import '../../models/name.dart';
import '../../models/profile.dart';
import '../../models/member.dart';
import '../../widgets/loading_dialog.dart';

class CreateMemberScreen extends StatefulWidget {
  const CreateMemberScreen({super.key});

  @override
  State<CreateMemberScreen> createState() => _CreateMemberScreenState();
}

class _CreateMemberScreenState extends State<CreateMemberScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _mainCommitteeDesignationController = TextEditingController();
  final TextEditingController _yuvaCommitteeDesignationController = TextEditingController();

  bool _isMainCommitteeMember = false;
  bool _isYuvaCommitteeMember = false;
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Member"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "First Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "First Name is Required!!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Last Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Last Name is Required!!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _mobileNoController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                    labelText: "Mobile No",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mobile No is Required!!";
                    }
                    if (value.length != 10) {
                      return "Mobile no must be 10 digits long!!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: CheckboxListTile(
                  title: const Text("Admin"),
                  value: _isAdmin,
                  onChanged: (value) => setState(() {
                    _isAdmin = value ?? false;
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: CheckboxListTile(
                  title: const Text("Main Committee Member"),
                  value: _isMainCommitteeMember,
                  onChanged: (value) => setState(() {
                    _isMainCommitteeMember = value ?? false;
                  }),
                ),
              ),
              if (_isMainCommitteeMember) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownMenu<String>(
                        menuHeight: 300,
                        width: deviceWidth - 32,
                        label: const Text("Select Main Committee Designation"),
                        controller: _mainCommitteeDesignationController,
                        initialSelection: _mainCommitteeDesignationController.text,
                        dropdownMenuEntries: CommitteeDesignation.values
                            .map((designation) => DropdownMenuEntry(
                                  value: designation.value,
                                  label: designation == CommitteeDesignation.none
                                      ? "Select Designation"
                                      : designation.value.capitalize!,
                                ))
                            .toList(),
                        onSelected: (value) {
                          _mainCommitteeDesignationController.text = (value ?? "").capitalize!;
                        },
                      ),
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: CheckboxListTile(
                  title: const Text("Yuva Committee Member"),
                  value: _isYuvaCommitteeMember,
                  onChanged: (value) => setState(() {
                    _isYuvaCommitteeMember = value ?? false;
                  }),
                ),
              ),
              if (_isYuvaCommitteeMember) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownMenu<String>(
                        menuHeight: 300,
                        width: deviceWidth - 32,
                        label: const Text("Select Yuva Committee Designation"),
                        controller: _yuvaCommitteeDesignationController,
                        initialSelection: _yuvaCommitteeDesignationController.text,
                        dropdownMenuEntries: CommitteeDesignation.values
                            .map((designation) => DropdownMenuEntry(
                                  value: designation.value,
                                  label: designation == CommitteeDesignation.none
                                      ? "Select Designation"
                                      : designation.value.capitalize!,
                                ))
                            .toList(),
                        onSelected: (value) {
                          _yuvaCommitteeDesignationController.text = (value ?? "").capitalize!;
                        },
                      ),
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: ElevatedButton(
                  onPressed: _createAccount,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Text("Create Account"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid Form
      return;
    }

    // Show Loading Dialog
    Get.dialog(const LoadingDialog(text: "Creating Account..."));

    RegisterRequest registerRequest = RegisterRequest();
    registerRequest.firstName = _firstNameController.value.text.trim();
    registerRequest.lastName = _lastNameController.value.text.trim();
    registerRequest.mobileNo = _mobileNoController.value.text.trim();
    registerRequest.isAdmin = _isAdmin;
    if (_isMainCommitteeMember && _isYuvaCommitteeMember) {
      registerRequest.committeeType = CommitteeType.both;
    } else if (_isMainCommitteeMember) {
      registerRequest.committeeType = CommitteeType.main;
    } else if (_isYuvaCommitteeMember) {
      registerRequest.committeeType = CommitteeType.yuva;
    } else {
      registerRequest.committeeType = CommitteeType.na;
    }
    if (_isMainCommitteeMember) {
      registerRequest.mainCommitteeDesignation = _mainCommitteeDesignationController.value.text.trim();
    }
    if (_isYuvaCommitteeMember) {
      registerRequest.yuvaCommitteeDesignation = _yuvaCommitteeDesignationController.value.text.trim();
    }

    ApiResponse<void> createMemberResponse = await AuthService().register(registerRequest);

    if (createMemberResponse.success) {
      ApiResponse<AddressStatistics> addressStatisticsResponse = await _addressService.getAddressStatistics();
      if (addressStatisticsResponse.success && addressStatisticsResponse.data != null) {
        AddressStatistics addressStatistics = addressStatisticsResponse.data!;
        addressStatistics.areaStatistics.incrementBy(member.area, 1, 1);
        addressStatistics.nativePlaceStatistics.incrementBy(member.nativePlace, 1, 1);

        await _addressService.setAddressStatistics(addressStatisticsResponse.data!);
      }

      // Close Dialog
      Get.back();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Member Created Successfully!!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));

        // Go Back
        Future.delayed(const Duration(seconds: 2), () => Get.back());
      }
    } else {
      // Close Dialog
      Get.back();

      // Show Other Exception
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(createMemberResponse.message),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 2),
        ));
      }
    }
  }
}
