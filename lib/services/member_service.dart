import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sjym_app/models/api_response.dart';
import 'package:sjym_app/models/committee_designation.dart';
import 'package:sjym_app/models/committee_type.dart';
import 'package:sjym_app/models/member.dart';
import 'package:sjym_app/provider/cache_provider.dart';
import 'package:sjym_app/provider/storage_provider.dart';
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

    final List<Member> members = await MemberRepository().findMembersByCommitteeType(committeeType);

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

  Future<ApiResponse<Member>> getMembersByMobileNo(String mobileNumber) async {
    final Member? member = await MemberRepository().findByUsername(mobileNumber);
    if (member != null) {
      return ApiResponse(data: member);
    }
    return ApiResponse(isError: true, message: "Member Not Found!!");
  }

  Future<ApiResponse<List<Member>>> getUsersByParams({String? name, String? area, String? nativePlace}) async {
    try {
      final List<Member> members = await MemberRepository().findUsersByParams(name, area, nativePlace);
      return ApiResponse(data: members);
    } catch (error) {
      log(error.toString(), name: runtimeType.toString(), error: error);
      return ApiResponse(isError: true, message: error.toString());
    }
  }

  Future<List<Member>> getFamilyMembers(String familyId) async {
    List<Member> familyMembers = _cacheProvider.getFamilyMembers(familyId);
    if (familyMembers.isNotEmpty) {
      return familyMembers;
    }
    familyMembers = await MemberRepository().findMembersByFamilyId(familyId);
    familyMembers.sort((m1, m2) {
      if (m1.profile.dob != null && m2.profile.dob != null) {
        return m1.profile.dob!.compareTo(m2.profile.dob!);
      }
      return -1;
    });
    for (var member in familyMembers) {
      debugPrint(member.toString());
    }
    _cacheProvider.setFamilyMembers(familyMembers, familyId);
    return familyMembers;
  }

  Future<String?> getProfileImageUrl(String profileImageFilepath) {
    return StorageProvider().getDownloadUrl(profileImageFilepath);
  }
}
