import 'dart:developer';

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
}
