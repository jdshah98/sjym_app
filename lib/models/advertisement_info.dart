import '../utils/helper.dart';
import '../utils/keys.dart';
import 'entity.dart';

class AdvertisementInfo extends Entity {
  String filepath;
  int expiry;

  AdvertisementInfo({
    this.filepath = '',
    int? expiry,
  }) : expiry = expiry ?? DateTime(1970).microsecondsSinceEpoch;

  static AdvertisementInfo fromMap(Map<String, dynamic>? map) {
    AdvertisementInfo advertisement = AdvertisementInfo();
    if (map != null) {
      advertisement.filepath = Helper.getString(map, Keys.filepath);
      advertisement.expiry = Helper.getInt(map, Keys.expiry) ?? DateTime(1970).microsecondsSinceEpoch;
    }
    return advertisement;
  }

  @override
  Map<String, dynamic> toMap() => {
        Keys.filepath: filepath,
        Keys.expiry: expiry,
      };
}
