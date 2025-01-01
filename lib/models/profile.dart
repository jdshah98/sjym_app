import '../utils/helper.dart';
import '../utils/keys.dart';
import 'entity.dart';

class Profile extends Entity {
  String mobileNumber;
  String thumbnail;
  String profilePic;
  String mainCommitteeDesignation;
  String yuvaCommitteeDesignation;
  String email;
  String education;
  String occupation;
  String officeAddress;
  String officeContact;
  int? dob;

  Profile({
    this.mobileNumber = '',
    this.thumbnail = '',
    this.profilePic = '',
    this.mainCommitteeDesignation = '',
    this.yuvaCommitteeDesignation = '',
    this.email = '',
    this.education = '',
    this.occupation = '',
    this.officeAddress = '',
    this.officeContact = '',
    int? dob,
  });

  String getDateOfBirth() => Helper.getFormattedDate(microseconds: dob) ?? 'NA';

  static Profile fromMap(Map<String, dynamic>? map) {
    final Profile profile = Profile();
    if (map != null) {
      profile.mobileNumber = Helper.getString(map, Keys.mobileNumber);
      profile.thumbnail = Helper.getString(map, Keys.thumbnail);
      profile.profilePic = Helper.getString(map, Keys.profilePic);
      profile.mainCommitteeDesignation = Helper.getString(map, Keys.mainCommitteeDesignation);
      profile.yuvaCommitteeDesignation = Helper.getString(map, Keys.yuvaCommitteeDesignation);
      profile.email = Helper.getString(map, Keys.email);
      profile.education = Helper.getString(map, Keys.education);
      profile.occupation = Helper.getString(map, Keys.occupation);
      profile.officeAddress = Helper.getString(map, Keys.officeAddress);
      profile.officeContact = Helper.getString(map, Keys.officeContact);
      profile.dob = Helper.getInt(map, Keys.dob);
    }
    return profile;
  }

  @override
  Map<String, dynamic> toMap() => {
        Keys.thumbnail: thumbnail,
        Keys.profilePic: profilePic,
        Keys.mainCommitteeDesignation: mainCommitteeDesignation,
        Keys.yuvaCommitteeDesignation: yuvaCommitteeDesignation,
        Keys.email: email,
        Keys.education: education,
        Keys.occupation: occupation,
        Keys.officeAddress: officeAddress,
        Keys.officeContact: officeContact,
        Keys.dob: dob,
      };
}
