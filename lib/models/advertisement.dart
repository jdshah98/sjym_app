import '../utils/keys.dart';
import 'advertisement_info.dart';
import 'entity.dart';

class Advertisement extends Entity {
  AdvertisementInfo welcomeAdvertisement;
  List<AdvertisementInfo> appAdvertisementList;

  Advertisement({
    AdvertisementInfo? welcomeAdvertisement,
    List<AdvertisementInfo>? appAdvertisementList,
  })  : welcomeAdvertisement = welcomeAdvertisement ?? AdvertisementInfo(),
        appAdvertisementList = appAdvertisementList ?? [];

  static Advertisement fromMap(Map<String, dynamic>? map) {
    Advertisement advertisement = Advertisement();
    if (map != null) {
      advertisement.welcomeAdvertisement = AdvertisementInfo.fromMap(map[Keys.welcomeAdvertisement]);
      advertisement.appAdvertisementList = ((map[Keys.appAdvertisementList] ?? []) as List<Map<String, dynamic>>)
          .map((e) => AdvertisementInfo.fromMap(e))
          .toList();
    }
    return advertisement;
  }

  @override
  Map<String, dynamic> toMap() => {
        Keys.welcomeAdvertisement: welcomeAdvertisement.toMap(),
        Keys.appAdvertisementList: appAdvertisementList.map((e) => e.toMap()).toList(),
      };
}
