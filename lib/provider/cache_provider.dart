import 'package:get_storage/get_storage.dart';
import 'package:sjym_app/models/address_statistics.dart';
import 'package:sjym_app/models/advertisement.dart';
import 'package:sjym_app/models/committee_type.dart';
import 'package:sjym_app/models/member.dart';
import 'package:sjym_app/utils/constants.dart';
import 'package:sjym_app/utils/helper.dart';
import 'package:sjym_app/utils/keys.dart';

class CacheProvider {
  CacheProvider._internal();

  static final CacheProvider _instance = CacheProvider._internal();

  factory CacheProvider() => _instance;

  final GetStorage _cache = GetStorage(Constants.cacheContainer);
  final GetStorage _inMemory = GetStorage(Constants.memoryContainer);

  static const int _monthCache = 2592000; // seconds

  List<Member> getCommitteeMembersByType(CommitteeType committeeType) {
    List<dynamic> cachedValue = _cache.read<List<dynamic>>(_getCommitteeMembersKeyByType(committeeType)) ?? [];

    return cachedValue.map((e) => Member.fromMap(e)).toList();
  }

  bool isCommitteeMembersCacheExpired(CommitteeType committeeType) {
    final int cachedValue = _cache.read<int>(_getCommitteeMembersExpiryKeyByType(committeeType)) ?? -1;
    if (cachedValue == -1) {
      return true;
    }
    return Helper.isExpired(cachedValue);
  }

  void setCommitteeMembersByType(CommitteeType committeeType, List<Member> members) {
    final List<Map<String, dynamic>> valueToCache = members.map((e) => e.toMap()).toList();

    // set value
    _cache.write(_getCommitteeMembersKeyByType(committeeType), valueToCache);
    // set expiry
    _cache.write(_getCommitteeMembersExpiryKeyByType(committeeType),
        DateTime.now().add(const Duration(seconds: _monthCache)).microsecondsSinceEpoch);
  }

  void setAreaStatistics(AddressStatistics areaStatistics) {
    _inMemory.writeInMemory(Keys.areaStatistics, areaStatistics.toMap());
  }

  void setNativePlaceStatistics(AddressStatistics nativePlaceStatistics) {
    _inMemory.writeInMemory(Keys.nativePlaceStatistics, nativePlaceStatistics.toMap());
  }

  AddressStatistics? getAreaStatistics() {
    final Map<String, dynamic>? cachedValue = _inMemory.read<Map<String, dynamic>>(Keys.areaStatistics);
    if (cachedValue != null) {
      return AddressStatistics.fromMap(cachedValue);
    }
    return null;
  }

  AddressStatistics? getNativePlaceStatistics() {
    final Map<String, dynamic>? cachedValue = _inMemory.read<Map<String, dynamic>>(Keys.nativePlaceStatistics);
    if (cachedValue != null) {
      return AddressStatistics.fromMap(cachedValue);
    }
    return null;
  }

  void setAdvertisement(Advertisement advertisement) {
    _cache.write(Keys.advertisement, advertisement.toMap());
  }

  Advertisement? getAdvertisement() {
    Map<String, dynamic>? cachedValue = _cache.read<Map<String, dynamic>>(Keys.advertisement);
    if (cachedValue != null) {
      return Advertisement.fromMap(cachedValue);
    }
    return null;
  }

  /// private methods
  String _getCommitteeMembersKeyByType(CommitteeType committeeType) =>
      committeeType == CommitteeType.main ? Keys.mainCommitteeMembers : Keys.yuvaCommitteeMembers;

  String _getCommitteeMembersExpiryKeyByType(CommitteeType committeeType) =>
      committeeType == CommitteeType.main ? Keys.mainCommitteeMembersExpiry : Keys.yuvaCommitteeMembersExpiry;
}
