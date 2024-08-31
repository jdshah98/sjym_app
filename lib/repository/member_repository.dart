import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sjym_app/models/member.dart';
import 'package:sjym_app/utils/keys.dart';

class MemberRepository {
  MemberRepository._internal();

  static final MemberRepository _instance = MemberRepository._internal();

  factory MemberRepository() => _instance;

  final CollectionReference<Map<String, dynamic>> _ref = FirebaseFirestore.instance.collection("members");

  Future<Member?> findByUsername(String username) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _ref.where(Keys.username, isEqualTo: username).get();
    if (querySnapshot.size == 0) {
      log("Member Not Found with Username: $username");
      return null;
    }

    final QueryDocumentSnapshot<Map<String, dynamic>> snapshot = querySnapshot.docs.first;
    if (!snapshot.exists) {
      log("Member Not Found with Username: $username");
      return null;
    }

    return Member.fromMap(snapshot.data());
  }
}
