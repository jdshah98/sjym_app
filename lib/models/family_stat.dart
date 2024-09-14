import 'entity.dart';
import '../utils/helper.dart';
import '../utils/keys.dart';

class FamilyStat extends Entity {
  int familyCount;
  int familyMemberCount;

  FamilyStat({this.familyCount = 0, this.familyMemberCount = 0});

  static FamilyStat fromMap(Map<String, dynamic>? map) {
    FamilyStat areaFamilyCount = FamilyStat();
    if (map != null) {
      areaFamilyCount.familyCount = Helper.getInt(map, Keys.familyCount) ?? 0;
      areaFamilyCount.familyMemberCount = Helper.getInt(map, Keys.familyMemberCount) ?? 0;
    }
    return areaFamilyCount;
  }

  @override
  Map<String, dynamic> toMap() => {
        Keys.familyCount: familyCount,
        Keys.familyMemberCount: familyMemberCount,
      };

  @override
  String toString() => toMap().toString();
}
