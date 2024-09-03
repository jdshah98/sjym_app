import 'package:sjym_app/models/family_stat.dart';
import 'package:sjym_app/models/entity.dart';

class AddressStatistics extends Entity {
  Map<String, FamilyStat> stats;

  AddressStatistics({Map<String, FamilyStat>? stats}) : stats = stats ?? {};

  static AddressStatistics fromMap(Map<String, dynamic>? map) {
    AddressStatistics addressStatistics = AddressStatistics();
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
