import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/api_response.dart';
import '../models/committee_designation.dart';
import '../models/committee_type.dart';
import '../models/member.dart';
import '../provider/cache_provider.dart';
import '../provider/storage_provider.dart';
import '../repository/member_repository.dart';

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
    return ApiResponse(isError: true, message: 'Member Not Found!!');
  }

  Future<ApiResponse<List<Member>>> getUsersByParams({String? name, String? area, String? nativePlace}) async {
    try {
      final List<Member> members = await MemberRepository().findUsersByParams(name, area, nativePlace);
      return ApiResponse(data: members);
    } catch (err) {
      log(err.toString(), error: err, name: runtimeType.toString());
      debugPrint(err.toString());
      return ApiResponse(isError: true, message: err.toString());
    }
  }

  Future<List<Member>> getFamilyMembers(String familyId) async {
    List<Member> familyMembers = _cacheProvider.getFamilyMembers(familyId);
    if (familyMembers.isNotEmpty) {
      return familyMembers;
    }
    familyMembers = await MemberRepository().findMembersByFamilyId(familyId);
    familyMembers.sort((m1, m2) => m1.familyOrder.compareTo(m2.familyOrder));
    for (var member in familyMembers) {
      debugPrint(member.toString());
    }
    _cacheProvider.setFamilyMembers(familyId, familyMembers);
    return familyMembers;
  }

  Future<String?> getProfileImageUrl(String profileImageFilepath) {
    return StorageProvider().getDownloadUrl(profileImageFilepath);
  }

  Future<ApiResponse<void>> setProfileImageUrl(File localFile, String imageFilepath) async {
    bool result = await StorageProvider().uploadImage(localFile, imageFilepath).then<bool>((value) {
      if (value.state == TaskState.success) {
        return true;
      }
      return false;
    }).onError((error, stackTrace) {
      log(stackTrace.toString(), error: error, name: runtimeType.toString());
      return false;
    });

    log("Profile Image Update Result: $result");

    return ApiResponse(
      isError: !result,
      message: result ? 'Profile Image Updated Successfully!!' : 'Failed to Update Profile Image!!',
    );
  }

  Future<ApiResponse<void>> deleteMember(Member member) async {
    try {
      await MemberRepository().removeById(member.uid);
      return ApiResponse(message: 'Member Deleted Successfully!!');
    } catch (err) {
      log(err.toString(), error: err, name: runtimeType.toString());
      debugPrint(err.toString());
      return ApiResponse(isError: true, message: err.toString());
    }
  }

  Future<ApiResponse<Member>> saveMember(Member member) async {
    try {
      Member savedMember = await MemberRepository().save(member);
      return ApiResponse(data: savedMember, message: 'Member Saved Successfully!!');
    } catch (err) {
      log(err.toString(), error: err, name: runtimeType.toString());
      debugPrint(err.toString());
      return ApiResponse(isError: true, message: 'Failed to Save Member!! Please try again later!!');
    }
  }

  Future<ApiResponse<Member>> updateMember(Member member) async {
    try {
      Member updatedMember = await MemberRepository().save(member);
      return ApiResponse(data: updatedMember, message: 'Member Updated Successfully!!');
    } catch (err) {
      log(err.toString(), error: err, name: runtimeType.toString());
      debugPrint(err.toString());
      return ApiResponse(isError: true, message: err.toString());
    }
  }
}
