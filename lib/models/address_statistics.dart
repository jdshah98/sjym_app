import 'address_type.dart';
import '../utils/constants.dart';

import 'family_stat.dart';
import 'entity.dart';

class AddressStatistics extends Entity {
  AddressType addressType;
  late Map<String, FamilyStat> stats;

  AddressStatistics(this.addressType, {Map<String, FamilyStat>? stats}) {
    if (stats == null) {
      if (addressType == AddressType.area) {
        this.stats = {for (var element in Constants.areaList) element: FamilyStat()};
      } else {
        this.stats = {for (var element in Constants.nativePlaceList) element: FamilyStat()};
      }
    } else {
      this.stats = stats;
    }
  }

  static AddressStatistics fromMap(AddressType addressType, Map<String, dynamic>? map) {
    AddressStatistics addressStatistics = AddressStatistics(addressType);
    if (map != null) {
      addressStatistics.stats = map.map(
        (key, value) => MapEntry(
          key,
          FamilyStat.fromMap((value ?? {}) as Map<String, dynamic>),
        ),
      );
    }
    return addressStatistics;
  }

  @override
  Map<String, dynamic> toMap() => stats.map((key, value) => MapEntry(key, value.toMap()));

  @override
  String toString() => toMap().toString();
}
