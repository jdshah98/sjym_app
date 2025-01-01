import 'package:sjym_app/models/entity.dart';
import 'package:sjym_app/utils/helper.dart';
import 'package:sjym_app/utils/keys.dart';

class Family extends Entity {
  String id;
  String address;
  String area;
  String nativePlace;

  Family({
    this.id = '',
    this.address = '',
    this.area = '',
    this.nativePlace = '',
  });

  static Family fromMap(Map<String, dynamic>? map) {
    Family family = Family();
    if (map != null) {
      family.id = Helper.getString(map, Keys.familyId);
      family.address = Helper.getString(map, Keys.address);
      family.area = Helper.getString(map, Keys.area);
      family.nativePlace = Helper.getString(map, Keys.nativePlace);
    }
    return family;
  }

  @override
  Map<String, dynamic> toMap() => {
        Keys.familyId: id,
        Keys.address: address,
        Keys.area: area,
        Keys.nativePlace: nativePlace,
      };

  @override
  String toString() => toMap().toString();
}
