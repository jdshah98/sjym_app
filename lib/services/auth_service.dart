import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sjym_app/models/name.dart';
import 'package:sjym_app/models/profile.dart';
import 'package:sjym_app/models/register_request.dart';

import '../models/api_response.dart';
import '../models/member.dart';
import '../repository/member_repository.dart';

import '../models/login_request.dart';

class AuthService {
  AuthService._internal();

  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  Future<ApiResponse<Member?>> login(LoginRequest loginRequest) async {
    Member? member = await MemberRepository().findByUsername(loginRequest.username);
    if (member == null || member.password != loginRequest.password) {
      log('Invalid Username or Password!!');
      return ApiResponse(message: 'Invalid Username or Password!!', isError: true);
    }
    return ApiResponse(data: member);
  }

  Future<ApiResponse<Member>> register(RegisterRequest registerRequest) async {
    Member member = Member(
      username: registerRequest.mobileNo.trim(),
      password: registerRequest.mobileNo.trim().substring(5),
      isAdmin: registerRequest.isAdmin,
      committeeType: registerRequest.committeeType.value,
      name: Name(
        firstName: registerRequest.firstName.trim(),
        lastName: registerRequest.lastName.trim(),
      ),
      profile: Profile(
        mobileNumber: registerRequest.mobileNo.trim(),
        mainCommitteeDesignation: registerRequest.mainCommitteeDesignation,
        yuvaCommitteeDesignation: registerRequest.yuvaCommitteeDesignation,
      ),
    );

    bool memberExists = await MemberRepository().existsByUsername(member.username);

    if (memberExists) {
      return ApiResponse(isError: true, message: 'Member Already Exists!!');
    }

    try {
      Member savedMember = await MemberRepository().save(member);
      return ApiResponse(data: savedMember, message: 'Member Created Successfully!!');
    } catch (err) {
      log(err.toString(), error: err, name: runtimeType.toString());
      debugPrint(err.toString());
      return ApiResponse(isError: true, message: 'Failed to Save Member!!Please try again later!!');
    }
  }
}
