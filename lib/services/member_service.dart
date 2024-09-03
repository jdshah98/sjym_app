import 'package:sjym_app/models/committee_designation.dart';
import 'package:sjym_app/models/committee_type.dart';
import 'package:sjym_app/models/member.dart';
import 'package:sjym_app/provider/cache_provider.dart';
import 'package:sjym_app/repository/member_repository.dart';

class MemberService {
  MemberService._internal();

  static final MemberService _instance = MemberService._internal();

  factory MemberService() => _instance;

  final CacheProvider _cacheProvider = CacheProvider();

  Future<List<Member>> getCommitteeMembers(CommitteeType committeeType) async {
    if (!_cacheProvider.isCommitteeMembersCacheExpired(committeeType)) {
      // get value from cache
      return _cacheProvider.getCommitteeMembersByType(committeeType);
    }

    List<Member> members = await MemberRepository().findMembersByCommitteeType(committeeType);

    if (committeeType == CommitteeType.main) {
      members.sort((member1, member2) => CommitteeDesignation.byValue(member1.profile.mainCommitteeDesignation)
          .compareTo(CommitteeDesignation.byValue(member2.profile.mainCommitteeDesignation)));
    } else {
      members.sort((member1, member2) => CommitteeDesignation.byValue(member1.profile.yuvaCommitteeDesignation)
          .compareTo(CommitteeDesignation.byValue(member2.profile.yuvaCommitteeDesignation)));
    }

    // set value in cache
    _cacheProvider.setCommitteeMembersByType(committeeType, members);

    return members;
  }

  Future<List<Member>> getMembersByArea(String area, int pageSize, List<Member>? lastResult) async {
    return await MemberRepository().findMembersByArea(area, pageSize, lastResult);
  }

  Future<List<Member>> getMembersByNativePlace(String nativePlace, int pageSize, List<Member>? lastResult) async {
    return await MemberRepository().findMembersByNativePlace(nativePlace, pageSize, lastResult);
  }
}
