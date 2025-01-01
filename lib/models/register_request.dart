import 'package:sjym_app/models/committee_type.dart';

class RegisterRequest {
  String firstName;
  String lastName;
  String mobileNo;
  bool isAdmin;
  CommitteeType committeeType;
  String mainCommitteeDesignation;
  String yuvaCommitteeDesignation;

  RegisterRequest({
    this.firstName = '',
    this.lastName = '',
    this.mobileNo = '',
    this.isAdmin = false,
    this.committeeType = CommitteeType.na,
    this.mainCommitteeDesignation = '',
    this.yuvaCommitteeDesignation = '',
  });
}
