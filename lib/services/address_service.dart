import '../models/address_type.dart';

import '../models/address_statistics.dart';
import '../provider/cache_provider.dart';
import '../repository/address_repository.dart';

class AddressService {
  AddressService._internal();

  static final AddressService _instance = AddressService._internal();

  factory AddressService() => _instance;

  Future<AddressStatistics?> getAddressStatistics(AddressType addressType) {
    return addressType == AddressType.area ? getAreaStatistics() : getNativePlaceStatistics();
  }

  Future<AddressStatistics?> getAreaStatistics() async {
    AddressStatistics? areaStatistics = CacheProvider().getAreaStatistics();
    if (areaStatistics == null) {
      areaStatistics = await AddressRepository().fetchAreaStatistics();

      if (areaStatistics != null) {
        CacheProvider().setAreaStatistics(areaStatistics);
      }
    }

    return areaStatistics;
  }

  Future<AddressStatistics?> getNativePlaceStatistics() async {
    AddressStatistics? nativePlaceStatistics = CacheProvider().getNativePlaceStatistics();

    if (nativePlaceStatistics == null) {
      nativePlaceStatistics = await AddressRepository().fetchNativePlaceStatistics();

      if (nativePlaceStatistics != null) {
        CacheProvider().setNativePlaceStatistics(nativePlaceStatistics);
      }
    }

    return nativePlaceStatistics;
  }
}
