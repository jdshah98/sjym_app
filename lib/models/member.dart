import 'package:sjym_app/utils/helper.dart';

import 'entity.dart';
import 'name.dart';
import 'profile.dart';

import '../utils/keys.dart';

class Member extends Entity {
  String uid;
  String familyId;
  String username;
  String password;
  bool isAdmin;
  String area;
  String nativePlace;
  String gender;
  bool isMarried;
  bool showInMatrimony;
  String committeeType;
  String bloodGroup;
  Name name;
  Profile profile;
  int? lastUpdated;

  Member({
    this.uid = "",
    this.familyId = "",
    this.username = "",
    this.password = "",
    this.isAdmin = false,
    this.area = "",
    this.nativePlace = "",
    this.gender = "",
    this.isMarried = false,
    this.showInMatrimony = false,
    this.committeeType = "",
    this.bloodGroup = "",
    Name? name,
    Profile? profile,
  })  : name = name ?? Name(),
        profile = profile ?? Profile();

  static Member fromMap(Map<String, dynamic>? map) {
    final Member member = Member();
    if (map != null) {
      member.uid = Helper.getString(map, Keys.uid);
      member.familyId = Helper.getString(map, Keys.familyId);
      member.username = Helper.getString(map, Keys.username);
      member.password = Helper.getString(map, Keys.password);
      member.isAdmin = Helper.getBool(map, Keys.isAdmin);
      member.area = Helper.getString(map, Keys.area);
      member.nativePlace = Helper.getString(map, Keys.nativePlace);
      member.gender = Helper.getString(map, Keys.gender);
      member.isMarried = Helper.getBool(map, Keys.isMarried);
      member.showInMatrimony = Helper.getBool(map, Keys.showInMatrimony);
      member.committeeType = Helper.getString(map, Keys.committeeType);
      member.bloodGroup = Helper.getString(map, Keys.bloodGroup);
      member.name = Name.fromMap(map[Keys.name]);
      member.profile = Profile.fromMap(map[Keys.profile]);
      member.lastUpdated = Helper.getInt(map, Keys.lastUpdated);
    }
    return member;
  }

  @override
  Map<String, dynamic> toMap() => {
        Keys.uid: uid,
        Keys.familyId: familyId,
        Keys.username: username,
        Keys.password: password,
        Keys.isAdmin: isAdmin,
        Keys.area: area,
        Keys.nativePlace: nativePlace,
        Keys.gender: gender,
        Keys.isMarried: isMarried,
        Keys.showInMatrimony: showInMatrimony,
        Keys.committeeType: committeeType,
        Keys.bloodGroup: bloodGroup,
        Keys.name: name.toMap(),
        Keys.profile: profile.toMap(),
        Keys.lastUpdated: lastUpdated
      };

  @override
  String toString() {
    return toMap().toString();
  }
}
